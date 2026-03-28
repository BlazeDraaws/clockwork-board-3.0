class_name BeatManagerComponent extends Node

# === CORE ===
var beat_components: Array = [] # managed list (no dict)
var LowestBeatComp : BeatComponent
var LowestBeatCompValue : float = INF

# === UNDO ===
@onready var UndoComp : UndoRedo = UndoRedo.new()

# === SCENE REFERENCES ===
@onready var HeroContainer = $"../Heroes/Container"
@onready var EnemyContainer = $"../Enemies/Container"

# === OPTIONAL UI ===
@onready var beat_manager_buttons: HBoxContainer = $"../Window/DebugComponent/Debug Container/BeatManagerButtons"

# === SPAWN ZONES ===
@onready var spawn_slots: Node = $"../Enemies/SpawnSlots"
var slot_occupants := {} # slot -> entity
# === REGISTER SYSTEM ===
# call this from BeatComponent _ready()
func register_beat(comp: BeatComponent):
	if comp in beat_components:
		return
		
	beat_components.append(comp)
	comp.tree_exited.connect(_on_beat_removed.bind(comp))

func _on_beat_removed(comp):
	beat_components.erase(comp)
	free_slot(comp.EntityComp)

# === ENTITY SPAWN ===
# simple helper for instantiating entity scenes
func spawn_entity(scene: PackedScene, container: Node):
	var entity = scene.instantiate()
	
	# SEARCH phase
	for slot in spawn_slots.get_children():
		if not slot_occupants.has(slot):
			entity.position = slot.position+Vector2(0,-200)
			slot_occupants[slot] = entity
			EnemyContainer.add_child(entity)
			print(slot.global_position)
			return entity
	
	# FALLBACK phase
	entity.global_position = get_random_screen_position()
	EnemyContainer.add_child(entity)
	return entity

func get_spawn_position() -> Vector2:
	for slot in spawn_slots.get_children():
		if not slot_occupants.has(slot):
			return slot.global_position
	return get_random_screen_position()

func free_slot(entity):
	for slot in slot_occupants:
		if slot_occupants[slot] == entity:
			slot_occupants.erase(slot)
			return

func get_random_screen_position() -> Vector2:
	var rect = get_viewport().get_visible_rect()
	
	return Vector2(
		randf_range(rect.position.x-1000, rect.end.x-1000),
		randf_range(rect.position.y, rect.end.y)
	)

# === FIND LOWEST ===
func _FindLowest():
	LowestBeatComp = null
	LowestBeatCompValue = INF
	
	for comp in beat_components:
		if not is_instance_valid(comp):
			continue
		
		var value = comp.beat / comp.speedvalue
		
		if value > 0 and value < LowestBeatCompValue:
			LowestBeatCompValue = value
			LowestBeatComp = comp

# === COMBO DETECTION ===
# returns array of BeatComponents that share the same timing
func _GetComboGroup():
	var combo := []
	
	if LowestBeatComp == null:
		return combo
	
	for comp in beat_components:
		if not is_instance_valid(comp):
			continue
			
		var value = comp.beat / comp.speedvalue
		
		if is_equal_approx(value, LowestBeatCompValue):
			combo.append(comp)
	
	return combo

# === HIGHLIGHT SYSTEM ===
func _HighlightNext():
	var combo_group = _GetComboGroup()
	
	for comp in combo_group:
		if comp == null:
			continue
		
		var entity = comp.get_parent()
		
		if entity != null and entity.has_method("highlighted"):
			entity.highlighted()

# === CORE BATCH SYSTEM ===
# this fixes undo batching
func _BatchBeatModify(amount: float):
	UndoComp.create_action("BatchBeatModify")

	for comp in beat_components:
		if not is_instance_valid(comp):
			continue
		
		var before = comp.beat
		var after = before + amount
		
		UndoComp.add_do_method(Callable(comp, "_setabsolutebeat").bind(after))
		UndoComp.add_undo_method(Callable(comp, "_setabsolutebeat").bind(before))

	UndoComp.commit_action()

# === NEXT FREE BEAT ===
func _NextFreeBeat():
	_FindLowest()
	
	if LowestBeatComp == null:
		return
	
	UndoComp.create_action("NextFreeBeat")
	
	for comp in beat_components:
		if not is_instance_valid(comp):
			continue
		
		var before = comp.beat
		var delta = LowestBeatCompValue * comp.speedvalue
		var after = before - delta
		
		UndoComp.add_do_method(Callable(comp, "_setabsolutebeat").bind(after))
		UndoComp.add_undo_method(Callable(comp, "_setabsolutebeat").bind(before))
	
	UndoComp.commit_action()
	
	_HighlightNext()

# === NEXT BEAT (tick forward) ===
func _NextBeat():
	_BatchBeatModify(-1)
	_HighlightNext()

# === RANDOMIZE (kept compatible) ===
func _randomize(shift_pressed):
	UndoComp.create_action("Randomize")
	
	for comp in beat_components:
		if not is_instance_valid(comp):
			continue
		
		var before_beat = comp.beat
		var before_speed = comp.speedvalue
		var before_drag = comp.drag
		
		var new_beat = randi_range(1, 10)
		var new_speed = comp.speedvalue
		var new_drag = comp.drag
		
		if shift_pressed:
			new_speed = [0,0.5,1,2,4].pick_random()
			new_drag = randi_range(-2, 2)
		
		# DO
		UndoComp.add_do_method(Callable(comp, "_setabsolutebeat").bind(new_beat))
		UndoComp.add_do_method(Callable(comp, "_speed").bind(new_speed))
		UndoComp.add_do_method(Callable(comp, "_setdrag").bind(new_drag))
		
		# UNDO
		UndoComp.add_undo_method(Callable(comp, "_setabsolutebeat").bind(before_beat))
		UndoComp.add_undo_method(Callable(comp, "_speed").bind(before_speed))
		UndoComp.add_undo_method(Callable(comp, "_setdrag").bind(before_drag))
	UndoComp.commit_action()

# === GENERIC ORDER SYSTEM (kept for compatibility) ===
func _BeatOrder(function, value, RowBeatComp: BeatComponent, UseValue: bool):
	_BaseOrder(function, value, RowBeatComp, UseValue)

func _EntityOrder(function, value, RowEntityComp, UseValue: bool):
	_BaseOrder(function, value, RowEntityComp, UseValue)

func _BaseOrder(function, value, SpecifiedComp, UseValue: bool):
	UndoComp.create_action(str(function, value))
	
	if not SpecifiedComp.has_method("_undo" + function):
		print("Missing method:", "_undo" + function)
		return
	
	if UseValue:
		UndoComp.add_do_method(Callable(SpecifiedComp, function).bind(value))
		UndoComp.add_undo_method(Callable(SpecifiedComp, "_undo" + function).bind(value))
	else:
		UndoComp.add_do_method(Callable(SpecifiedComp, function))
		UndoComp.add_undo_method(Callable(SpecifiedComp, "_undo" + function))

	UndoComp.commit_action()

# === SEND ORDER (kept) ===
func _SendOrder(function, value, SpecifiedComp, UseValue: bool):
	var c = Callable(SpecifiedComp, function)
	
	if UseValue:
		c.call(value)
	else:
		c.call()

# === UNDO / REDO ===
func _UndoRedo(shift):
	if shift:
		UndoComp.redo()
	else:
		UndoComp.undo()

# === READY ===
func _ready():
	# auto-register existing beats (important for compatibility)
	_auto_register_existing()
	
	$"../Window/DebugComponent/Debug Container/BeatManagerButtons/Button".pressed.connect(_NextFreeBeat)
	$"../Window/DebugComponent/Debug Container/BeatManagerButtons/Button2".pressed.connect(_NextBeat)

# === AUTO REGISTER (so you don’t have to rewrite everything) ===
func _auto_register_existing():
	for EntityComp in HeroContainer.get_children():
		for BeatComp in EntityComp.get_children():
			if BeatComp is BeatComponent:
				register_beat(BeatComp)
	
	for EntityComp in EnemyContainer.get_children():
		for BeatComp in EntityComp.get_children():
			if BeatComp is BeatComponent:
				register_beat(BeatComp)
