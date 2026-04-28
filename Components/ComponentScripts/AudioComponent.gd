class_name AudioComponent extends AudioStreamPlayer

@export var music : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func playsound():
	if !music:
		pitch_scale = randf_range(0.9, 1.1)
		play()
