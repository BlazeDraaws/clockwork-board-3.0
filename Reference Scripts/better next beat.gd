extends Button

@onready var audio_player: AudioStreamPlayer2D = $"jinge up 2"
@onready var jingleup: AudioStreamPlayer2D = $"jingle up"
@onready var audio_player2: AudioStreamPlayer2D = $AudioStreamPlayer2D
var BarValues: Dictionary = {
	"test bar" = 100,
}

func _ready() -> void:
	pass
# Set up the timer for looping
func _on_pressed() -> void:
	print("Getting Info!")
	var beats_to_skip = BarValues.values()[0]
	for obj in BarValues:
		if BarValues[obj] < beats_to_skip:
			beats_to_skip = BarValues[obj]
	print("betternextbeat: skipped ",beats_to_skip," beats! ")
	get_tree().call_group("Beat Progress Bar", "_Next_Beat", beats_to_skip)
	if audio_player:
		print("PLAYING SOUND")
		print(audio_player)
		audio_player.pitch_scale = randf_range(0.8, 1.5)
		audio_player.play()
	if jingleup:
		print("PLAYING SOUND")
		print(jingleup)
		jingleup.pitch_scale = randf_range(0.9, 1.1)
		jingleup.play()
	if audio_player2:
		print("PLAYING SOUND")
		print(audio_player2)
		audio_player2.stop()
		audio_player2.pitch_scale = randf_range(0.5, 1.6)
		audio_player2.play()

func _info(beat, swinging, is_pull_mode, speed, dragset, notetype, usage, current_group):
	if current_group != "Beat Progress Bar":
		BarValues[current_group] = beat
		if BarValues[current_group] <= 0:
			BarValues.erase(current_group)
		print(BarValues)
