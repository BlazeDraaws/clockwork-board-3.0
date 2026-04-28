class_name AudioSceneManagerComponent extends Node

@onready var ready_sfx: AudioStreamPlayer = $Ready_SFX
@onready var cast_sfx: AudioStreamPlayer = $Cast_SFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func play(audio : AudioComponent):
	if audio:
		audio.play()
