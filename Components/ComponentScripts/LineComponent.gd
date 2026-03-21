class_name LineComponent extends BarComponent

var _progress_ratio = (value - min_value) / (max_value - min_value)
var global_rect = get_global_rect()
var orientation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BeatComp.specific_orientation == 0:
		orientation = EntityComp.DefaultOrientation
	else:
		orientation = BeatComp.specific_orientation
	if position.x == 0:
		position.x = 150
	if BeatComp.Secondary:
		texture_under = null
		texture_progress = texture_secondary
		position.y += 10
	if BeatComp == null:
		BeatComp = BackupBeat
	if EntityComp == null:
		EntityComp = BackupEntity
	scale.x *= orientation
	position.x *= orientation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if note:
		_progress_ratio = (value - min_value) / (max_value - min_value)
		global_rect = get_global_rect()
