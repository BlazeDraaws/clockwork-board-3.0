class_name EntityComponent extends Node


@export var freeform : bool = false
@export var SpriteComp : SpriteComponent
@export var MainBeatComp : BeatComponent
@export var DebugComp : DebugComponent
@export var DefaultOrientation : int = 1
@export var SpriteFlip : bool = false
@export var close : bool = true
@export var CustomCast : bool = false
@export var CastOgg : AudioStreamOggVorbis
@export var player : bool = false
@onready var beat : float
@onready var speed : float
@onready var drag : int
@onready var downedstate : bool
@onready var FreeFormContainer : Node2D = null
@onready var ControlContainer : Node2D = $"../../../Enemies/Container"
@onready var cast_sfx: AudioStreamPlayer = %AudioManagerComponent/Cast_SFX
@onready var ready_sfx: AudioStreamPlayer = %AudioManagerComponent/Ready_SFX
@onready var cast_mus: AudioStreamPlayer = $Cast_MUS
@onready var BeatManagerComp : BeatManagerComponent = $"../../../BeatManagerComponent"

# history
var range_history: Array = []
var history_limit:= 30
var upnext := false

func _ready() -> void:
	if CastOgg:
		cast_mus.stream = CastOgg
	MainBeatComp._update.connect(sync)
	
	for beatcomp in self.get_children():
		if beatcomp is BeatComponent:
			BeatManagerComp.register_beat(beatcomp)

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


func hurt():
	print(self.name, ": ow ive been hurt")

func _undo_switchrange(_close):
	if range_history.size() == 0:
		return
	close = range_history.pop_front()
	
func _undo_down():
	_down()

func sync(BeatCompChild : BeatComponent):
	if MainBeatComp == BeatCompChild:
		if MainBeatComp.beat <= 0 and beat > 0: # from beats to no beat
			if cast_mus:
				cast_mus.play()
			elif cast_sfx:
				cast_sfx.pitch_scale = randf_range(0.9, 1.1)
				cast_sfx.play(0.1)
		if MainBeatComp.beat > 0 and beat <= 0: # from no beats to beat
			if ready_sfx:
				ready_sfx.pitch_scale = randf_range(0.9, 1.1)
				ready_sfx.play()
		beat = MainBeatComp.beat
		speed = MainBeatComp.speedvalue
		drag = MainBeatComp.drag
		if SpriteComp:
			SpriteComp._update()
	else: #code for secondary beats
		if BeatCompChild.beat <= 0 and beat > 0: # from beats to no beat
			if cast_sfx:
				cast_sfx.pitch_scale = randf_range(0.9, 1.1)
				cast_sfx.play(0.1)
