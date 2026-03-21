class_name GUIComponent extends Node

@export var BeatComp : BeatComponent

func _update():
	for child in self.get_children():
		if child.has_method("_update"):
			child._update()
