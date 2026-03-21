class_name EntityComponent extends Node


@export var freeform : bool = false
@export var SpriteComp : SpriteComponent
@export var MainBeatComp : BeatComponent
@export var DebugComp : DebugComponent
@export var BeatManagerComp : BeatManagerComponent
@export var DefaultOrientation : int = 1
@export var SpriteFlip : bool = false
@export var close : bool = true
@onready var beat : float
@onready var speed : float
@onready var drag : int
@onready var downedstate : bool
@onready var FreeFormContainer : Node2D = null
@onready var ControlContainer : Node2D = $"../../../Enemies/Container"


# history
var range_history: Array = []
var history_limit:= 30
var upnext := false

func _ready() -> void:
	MainBeatComp._update.connect(sync)

func setfreeform():
	if freeform:
		reparent(FreeFormContainer, true)
	else:
		reparent(ControlContainer, true)

func _switchrange(_close):
	range_history.push_front(close)
	if range_history.size() > history_limit:
		range_history.pop_back()
	close = _close
	SpriteComp._update()

func _down():
	downedstate = !downedstate
	SpriteComp._update()
	for BeatComp in self.get_children():
		if BeatComp is BeatComponent:
			if downedstate:
				BeatComp._speed(0.0)
			else:
				BeatComp._undo_speed(0.0)


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
		SpriteComp._update()
