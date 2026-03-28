class_name ClefComponent extends BarAssetComponent

@export var ClefID : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EntityComp = $"../../.."
	BeatComp = $"../.."
	scale.x *= EntityComp.DefaultOrientation
	position.x *= EntityComp.DefaultOrientation
	if BeatComp.Secondary:
		visible = false
	if ClefID:
		play(str(ClefID))



func _physics_process(delta: float) -> void:
	if BeatComp.Secondary:
		return
	modulate.a = lerp(modulate.a, 1-clamp(BeatComp.beat,0.0,1.0), delta*8)
