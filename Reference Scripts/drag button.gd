class_name EventButton
extends Button

@onready var progress_bar : TextureProgressBar = null
signal left_click
signal right_click
var drag_value := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gui_input.connect(_on_Button_gui_input)
	# Get the group name the button is a part of (assuming the first group)
	var group_name = get_groups()[0]  # You can adjust this if the button belongs to multiple groups
	var group_members = get_tree().get_nodes_in_group(group_name)
	
	# Now find the first TextureProgressBar in the group
	for member in group_members:
		if member is TextureProgressBar:
			progress_bar = member
			break  # Stop once we find the first TextureProgressBar
	if progress_bar and !progress_bar.has_meta("drag"):
		progress_bar.set_meta("drag", drag_value)  # Initialize drag if not already set


# Called every frame to update the text
func _process(_delta) -> void:
	if progress_bar:
		text = "🠜 " + str(drag_value) + " 🠞"
	if drag_value > 0:
		self_modulate = Color(1, 0.50-drag_value/3, 0.50-drag_value/3)
	elif drag_value < 0:
		self_modulate = Color(0.80+drag_value/2-0.1, 1, 1)
	else:
		self_modulate = Color(1, 1, 1)

func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
				minusDrag(1)
			MOUSE_BUTTON_RIGHT:
				right_click.emit()
				addDrag(1)
				print("right")

func minusDrag(mult):
	drag_value -= 1*mult
	for group_name in get_groups():
		get_tree().call_group(group_name, "_drag", drag_value)
	print("left")
	
func addDrag(mult):
	drag_value += 1*mult
	for group_name in get_groups():
		get_tree().call_group(group_name, "_drag", drag_value)
	print("right")
