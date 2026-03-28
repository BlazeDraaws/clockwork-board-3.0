extends FoldableContainer

@onready var EntityComp : EntityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if EntityComp:
		self.title = EntityComp.name
	else:
		self.title = "[No EntityComp]"
