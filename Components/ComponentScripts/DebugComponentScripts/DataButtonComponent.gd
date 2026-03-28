extends HBoxContainer

@onready var data_input: LineEdit = $DataInput
@onready var data_button: Button = $DataButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	data_input.text = data_button.value
