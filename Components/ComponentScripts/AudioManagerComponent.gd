class_name AudioManagerComponent extends Node

@onready var EntityComp : EntityComponent = $".."
@onready var Cast: AudioComponent = $Cast
@onready var Ready: AudioStreamPlayer = $Ready
@onready var Hurt: AudioStreamPlayer = $Hurt
@onready var SecondaryCast: AudioComponent = $"Secondary Cast"
@onready var SecondaryReady: AudioComponent = $"Secondary Ready"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _update(BeatComp : BeatComponent):
	if BeatComp.beat_history:
		if BeatComp.beat <= 0 and BeatComp.beat_history.front() > 0: # from no beats to beat
			cast(BeatComp)
		elif BeatComp.beat > 0 and BeatComp.beat_history.front() <= 0: # from no beats to beat
			ready(BeatComp)


func ready(BeatComp : BeatComponent):
	if BeatComp.Secondary:
		play(SecondaryReady)
	else:
		play(Ready)

func cast(BeatComp : BeatComponent):
	if BeatComp.Secondary:
		play(SecondaryCast)
	else:
		play(Cast)

func hurt():
	play(Hurt)

func play(audio : AudioComponent):
	if audio:
		audio.playsound()
