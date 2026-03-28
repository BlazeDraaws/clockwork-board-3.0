class_name ControllerComponent extends Node

@export var Manager: BeatManagerComponent
# Called when the node enters the scene tree for the first time.

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_Z:
			Manager._UndoRedo(event.shift_pressed)
	if event is InputEventKey and event.pressed:
		if event.ctrl_pressed and event.keycode == KEY_R:
				Manager._randomize(event.shift_pressed)


# DONT FORGET TO DO THE HOVER CLICK BUTON BEAT THING 
