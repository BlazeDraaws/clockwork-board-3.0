extends VBoxContainer

@onready var EntityComp : EntityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if EntityComp:
		$Label.text = EntityComp.name
	else:
		$Label.text = "[No EntityComp]"
