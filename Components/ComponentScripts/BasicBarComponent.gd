class_name BarComponent extends TextureProgressBar

var color_base: Color
var newvalue : float = 0
var dragopacity : float = 1

@onready var SpriteAnim : AnimationPlayer = $"../../../SpriteComponent/AnimationPlayer"
@export var DynamicColour : bool = true
@export var texture_secondary : Texture
@export var AnimComp : AnimationPlayer
@export var DragComp : DragComponent
@export var note : NoteComponent
@export var ColorOverride : bool = true
@onready var BeatComp : BeatComponent = $"../.."
@onready var EntityComp : EntityComponent = $"../../.."
@export var BackupBeat : BeatComponent
@export var BackupEntity : EntityComponent

var currentanim

#dont use ready function here! it wont work

func _update():
	newvalue = BeatComp.beat*10
	
	for child in self.get_children():
		if child.has_method("_update"):
			child._update()

	if DynamicColour:
		dragopacity = clamp(BeatComp.drag,1,10)
		match BeatComp.speedvalue:
			4.0:
				_tint_node(self, Color(0.0, 0.515, 1.176, 1.0/dragopacity))
			2.0:
				_tint_node(self, Color(0.0, 1.0, 0.883, 1.0/dragopacity))
			1.0:
				_tint_node(self, Color(1.0, 1.0, 1.0, 1.0/dragopacity))
			0.5:
				_tint_node(self, Color(0.871, 0.191, 0.303, 1.0/dragopacity))
			0.0:
				_tint_node(self, Color(0.59, 0.429, 0.429, 1.0/dragopacity))

func _updateAnim(newanim):
		currentanim = newanim
		AnimComp.play(newanim)

func _physics_process(delta: float) -> void:
	if newvalue <= 0 and value < 0.5:
		value = lerp(value, newvalue, delta*8)
	else:
		value = lerp(value, newvalue, delta*4)

func _tint_node(node: Node, color: Color) -> void:
	if node.ColorOverride: #if node colour can be overridden
		(node as CanvasItem).self_modulate = color #change color
		color_base = color
		for child in node.get_children(): #do this for all overrideable children too
			if child is BarAssetComponent:
				_tint_node(child, color)
