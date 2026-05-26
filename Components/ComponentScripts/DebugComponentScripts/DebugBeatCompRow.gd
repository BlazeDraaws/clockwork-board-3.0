extends HBoxContainer

@onready var BeatComp : BeatComponent

func _ready() -> void:
	if BeatComp:
		$Label.text = BeatComp.name
	else:
		$Label.text = "[No BeatComp]"
	
