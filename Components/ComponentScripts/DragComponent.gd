class_name DragComponent extends Control

@onready var BeatComp : BeatComponent = $"../../.."
@onready var DragTop : AnimatedSprite2D = $DragTop
@onready var DragBottom : AnimatedSprite2D = $DragBottom
@onready var AnimPlayer : AnimationPlayer = $DragPlayer
@onready var Entered : bool = false
var Hidden : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BeatComp.Secondary:
		Hidden = true
		visible = false
		DragTop.set_frame(randi_range(1,3)*4 - 4)
	else:
		visible = true
		modulate.a = 0

func _update():
	if !Hidden:
		if BeatComp.drag > 0 and !Entered:
			AnimPlayer.play("DragTween/Enter")
			Entered = true
		elif BeatComp.drag <= 0 and Entered:
			AnimPlayer.play("DragTween/Exit")
			Entered = false
		if BeatComp.drag >= 5:
			DragBottom.set_frame(randi_range(1,3)*4 - 4)
			DragBottom.play("Stage 2")
		else:
			DragBottom.set_frame(randi_range(1,3)*4 - 4)
			DragBottom.play("Stage 1")

func _process(delta: float) -> void:
	if !Hidden:
		modulate.a = lerp(modulate.a, BeatComp.drag/5.0, delta * 5)  # Smooth transition
