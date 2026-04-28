class_name GUIComponent extends Node

@export var BeatComp : BeatComponent
const LINE_COMPONENT = preload("uid://41gfk3tasqsy")
const RING_COMPONENT = preload("uid://5tvmldk0wneg")


func _addGUI(line):
	
	if line:
		var node = LINE_COMPONENT.instantiate()
		add_child(node)
	else:
		var node = RING_COMPONENT.instantiate()
		add_child(node)
	_update()
	

func _update():
	for child in self.get_children():
		if child.has_method("_update"):
			child._update()
