class_name GUIComponent extends Node

@export var BeatComp : BeatComponent
const LINE_COMPONENT = preload("uid://41gfk3tasqsy")
const RING_COMPONENT = preload("uid://5tvmldk0wneg")
var bar

func _addGUI(line):
	
	if line:
		bar = LINE_COMPONENT.instantiate()
		add_child(bar)
	else:
		bar = RING_COMPONENT.instantiate()
		add_child(bar)
	_update()
	

func _update():
	for child in self.get_children():
		if child.has_method("_update"):
			child._update()
