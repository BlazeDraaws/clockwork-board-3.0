extends DebugButtonComponent

func _ready() -> void:
	pressed.connect(_on_pressed)
	_IDPressed.connect(BeatManager._EntityOrder)
	
func _process(_delta: float) -> void:
	button_pressed = EntityRow.EntityComp.downedstate

func _on_pressed():
	_IDPressed.emit(function, value, EntityRow.EntityComp, UseValue)
