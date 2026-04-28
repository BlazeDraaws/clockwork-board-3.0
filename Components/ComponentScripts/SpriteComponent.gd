class_name SpriteComponent extends AnimatedSprite2D

@onready var EntityComp : EntityComponent = $".."
@onready var AnimComp : AnimationPlayer = $"AnimationPlayer"
@export var BackupAnim : AnimationPlayer
@export var BackupComp : EntityComponent
@export var placeholder : bool

var Orientation : int = 1
var CurrentAnim
var Close = "_Close"
var Far = "_Far"
var closerange : bool
func _ready() -> void:
	if EntityComp.SpriteFlip:
		scale.x = -0.5
		Far = "_Close"
		Close = "_Far"
	if EntityComp == null:
		EntityComp = BackupComp
	if AnimComp == null:
		AnimComp = BackupAnim
		
func _update(_beatcomp):
	if EntityComp.downedstate:
		_PlayerAnim("Downed")
		self.self_modulate.a = 0.2
		return
	else:
		self.self_modulate.a = 1
	
	
	if EntityComp.close:
		if !closerange:
			closerange = true
			_PlayerAnim(Close)
	else:
		if closerange:
			closerange = false
			_PlayerAnim(Far)

	if EntityComp.beat > 0:
		if animation == "Cast":
			await animation_finished
		_PlayerAnim("Ready")
	elif EntityComp.beat <= 0 && animation == "Ready":
		_PlayerAnim("Cast")
	else:
		_PlayerAnim("Idle")

func _PlayerAnim(animID):
	var animcompanimID = str("AnimationPlayerTweens/", animID)
	if placeholder:
		return
	if sprite_frames.has_animation(animID) and animation != animID:
		play(animID)
	if AnimComp:
		if AnimComp.has_animation(animcompanimID) and CurrentAnim != animcompanimID:
			CurrentAnim = animcompanimID
			AnimComp.play(animcompanimID)
