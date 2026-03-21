extends DebugButtonComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	_IDPressed.connect(BeatManager._BeatOrder)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_pressed():
	_IDPressed.emit(function, value, BeatCompRow.BeatComp, UseValue)
