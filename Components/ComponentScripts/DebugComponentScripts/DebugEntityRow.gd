extends FoldableContainer

@onready var EntityComp : EntityComponent

func _process(_delta: float) -> void:
	if EntityComp:
		self.title = str(EntityComp.name, "          || Beat: ", EntityComp.beat, " | Speed: ", EntityComp.speed, " | Drag: ", EntityComp.drag, " | Down: ", EntityComp.downedstate, " | Confuse: ", EntityComp.confused, " ||")
	else:
		self.title = "[No EntityComp]"
