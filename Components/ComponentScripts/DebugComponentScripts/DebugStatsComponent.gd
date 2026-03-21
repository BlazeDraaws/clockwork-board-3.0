extends Control


@onready var BeatComp : BeatComponent = $"../.."
@export var BackupBeat : BeatComponent

@onready var Beat : Label = $Beat
@onready var Drag : Label = $Drag
@onready var Speed : Label = $Speed

func _ready() -> void:
	if BeatComp == null:
		BeatComp = BackupBeat
		
	if BeatComp.Secondary:
		position.y +=100


func _update():
	Beat.text = str(BeatComp.beat)
	Drag.text = str(BeatComp.drag)
	Speed.text = str(BeatComp.speedvalue)
