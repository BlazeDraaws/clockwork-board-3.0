class_name DebugComponent extends Control

# Scene references (where entities live)
@onready var HeroContainer = $"../../Heroes/Container"
@onready var EnemyContainer = $"../../Enemies/Container"

# UI scenes (what gets spawned in debug)
@export var EntityRowScene : PackedScene      # One row per entity
@export var BeatCompRowScene : PackedScene    # One row per beat component

# External systems
@export var BeatManagerComp : BeatManagerComponent

# Root UI container
@export var DebugGUI: Container


# Maps for tracking UI <-> real objects
var entity_map := {} # EntityComp -> EntityRow
var beat_map := {}   # BeatComp   -> BeatRow


# Called when scene loads
func _ready() -> void:

	# Register all existing heroes
	for EntityComp in HeroContainer.get_children():
		register_entity(EntityComp)

	# Register all existing enemies
	for EntityComp in EnemyContainer.get_children():
		register_entity(EntityComp)
	
	# Listen for NEW entities being added at runtime
	HeroContainer.child_entered_tree.connect(register_entity)
	EnemyContainer.child_entered_tree.connect(register_entity)



# Creates + tracks debug UI for an entity
func register_entity(EntityComp):

	# Spawn UI row
	var EntityRow = EntityRowScene.instantiate()
	EntityRow.EntityComp = EntityComp
	DebugGUI.add_child(EntityRow)

	# Store reference for cleanup / lookup
	entity_map[EntityComp] = EntityRow


	# When entity is deleted → remove its UI
	# tree_exiting fires just before it's gone
	EntityComp.tree_exiting.connect(_on_entity_removed.bind(EntityComp))


	# Register all BeatComponents under this entity
	for BeatComp in EntityComp.get_children():
		if BeatComp is BeatComponent:
			register_beat(EntityComp, BeatComp)



# Creates + tracks debug UI for a beat component
func register_beat(EntityComp, BeatComp):
	# Spawn UI row
	var BeatRow = BeatCompRowScene.instantiate()
	BeatRow.BeatComp = BeatComp

	# Find parent entity UI
	var EntityRow = entity_map[EntityComp]

	# Attach beat row under entity row
	EntityRow.get_node("VBoxContainer").add_child(BeatRow)

	# Store reference
	beat_map[BeatComp] = BeatRow


	# When beat component is deleted → remove its UI
	BeatComp.tree_exiting.connect(_on_beat_removed.bind(BeatComp))



# Cleanup when entity is removed
func _on_entity_removed(EntityComp):

	# Only act if we tracked it
	if entity_map.has(EntityComp):

		# Delete UI row (this also deletes its child BeatRows visually)
		entity_map[EntityComp].queue_free()

		# Remove from map
		entity_map.erase(EntityComp)

	# Note:
	# BeatRows will disappear visually,
	# but beat_map will still hold old references unless cleaned manually



# Cleanup when beat component is removed
func _on_beat_removed(BeatComp):

	if beat_map.has(BeatComp):

		# Delete UI row
		beat_map[BeatComp].queue_free()

		# Remove from map
		beat_map.erase(BeatComp)
