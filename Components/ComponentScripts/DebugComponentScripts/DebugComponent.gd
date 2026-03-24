class_name DebugComponent extends Control

@onready var HeroContainer = $"../../Heroes/Container"
@onready var EnemyContainer = $"../../Enemies/Container"
@export var EntityRowScene : PackedScene
@export var BeatCompRowScene : PackedScene
@export var BeatManagerComp : BeatManagerComponent
@export var DebugGUI: Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for EntityComp in HeroContainer.get_children():
		instantiateForEntityComps(EntityComp)
	for EntityComp in EnemyContainer.get_children():
		instantiateForEntityComps(EntityComp)


func instantiateForEntityComps(EntityComp):
	var EntityRow = EntityRowScene.instantiate()
	EntityRow.EntityComp = EntityComp
	DebugGUI.add_child(EntityRow)
	for BeatComp in EntityComp.get_children():
		if BeatComp is BeatComponent:
			var BeatRow = BeatCompRowScene.instantiate()
			BeatRow.BeatComp = BeatComp
			EntityRow.add_child(BeatRow)
