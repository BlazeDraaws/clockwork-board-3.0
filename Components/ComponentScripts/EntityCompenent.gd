class_name EntityComponent extends Node

@export var SpriteComp : SpriteComponent
@export var MainBeatComp : BeatComponent
@export var DebugComp : DebugComponent
@export var DefaultOrientation : int = 1
@export var SpriteFlip : bool = false
@export var close : bool = true
@export var AI : Node 
@onready var beat : float
@onready var speed : float
@onready var drag : int
@onready var downedstate : bool
@onready var clef : bool
@onready var confused : bool = false
# history
var range_history: Array = []
var history_limit:= 30
var upnext := false

func _exit_tree():
	Registry.unregister_entity(self)

func _ready() -> void:
	
	Registry.register_entity(self)

func _switchrange(_close):
	range_history.push_front(close)
	if range_history.size() > history_limit:
		range_history.pop_back()
	close = _close
	SpriteComp._update(MainBeatComp)

func _down():
	downedstate = !downedstate
	SpriteComp._update(MainBeatComp)
	for BeatComp in self.get_children():
		if BeatComp is BeatComponent:
			if downedstate:
				BeatComp._speed(0.0)
			else:
				BeatComp._undo_speed(0.0)

func hurt():
	SpriteComp._PlayerAnim("Hurt")
	print(self.name, ": ow ive been hurt")
	await SpriteComp.AnimComp.animation_finished
	SpriteComp.CurrentAnim = "Idle"
	for child in get_children():
		if child.has_method("on_hurt"):
			child.on_hurt()

func cancelturn():
	for child in get_children():
		if child.has_method("cancelturn"):
			child.cancelturn()

func _undocancelturn():
	print("cant uncancel turn sorry")
	
func setconfused(isconfused):
	confused = isconfused
	if self.is_in_group("Friendly"):
		for child in get_children():
			if child is BeatComponent:
				print(child.GUIComp.visible)
				child.GUIComp.visible = !confused

func _undosetconfused(isconfused):
	confused = !isconfused
	if self.is_in_group("Friendly"):
		for child in get_children():
			if child is BeatComponent:
				child.GUIComp.visible = !confused

func _undohurt():
	print(self.name, ": ow ive been unhurt")
	for child in get_children():
		if child.has_method("on_undohurt"):
			child.on_undohurt()

func kill():
	await get_tree().create_timer(0.1).timeout
	self.free()

func _undokill():
	pass

func highlighted():
	SpriteComp._PlayerAnim("UpNext")


func unhighlight():
	SpriteComp._PlayerAnim("UpNextCancel")

func _undo_switchrange(_close):
	if range_history.size() == 0:
		return
	close = range_history.pop_front()
	
func _undo_down():
	_down()

func sync(BeatCompChild : BeatComponent):
	if MainBeatComp == BeatCompChild:
		beat = MainBeatComp.beat
		speed = MainBeatComp.speedvalue
		drag = MainBeatComp.drag
	stack_nodes_vertically()

func get_beat_children():
	var result = []
	for child in get_children():
		if child is BeatComponent:
			result.append(child)

	return result



func stack_nodes_vertically(nodes: Array = get_beat_children(), spacing: float = 20.0):
	for i in range(nodes.size()):
		var node = nodes[i]
		var _offset = (nodes.size() - 1) * spacing * 0.5 #if you want centering use this
		
		if not is_instance_valid(node):
			continue
		
		if node.line:
			node.position.y = i * spacing + 200
			
