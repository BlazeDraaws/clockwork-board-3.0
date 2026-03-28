class_name NoteComponent extends BarAssetComponent

@onready var LineComp : LineComponent = $".."
@export var BackupLine : LineComponent

func _ready() -> void:
	BeatComp = $"../../.."
	if BeatComp == null:
		BeatComp = BackupBeat
	if LineComp == null:
		LineComp = BackupLine
	
func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a, clamp(LineComp._progress_ratio*80-0.2,0.0,1.0), delta*8)
	global_position.x = LineComp.global_rect.position.x + (LineComp._progress_ratio * LineComp.global_rect.size.x)*BeatComp.orientation
	if LineComp.value == 0.1:
		_Anim("0")

func _Anim(animID):
		if animation != animID:
			play(animID)



func _update():
	if BeatComp.Secondary:
		_Anim("Secondary")
		position.y = 16
	else:
		_Anim(str(BeatComp.notetype))
		position.y = 4
