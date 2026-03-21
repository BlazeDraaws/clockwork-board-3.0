extends BarComponent



var orientation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BeatComp.Secondary:
		texture_under = null
		texture_progress = texture_secondary
	if BeatComp == null:
		BeatComp = BackupBeat
	if EntityComp == null:
		EntityComp = BackupEntity
	if AnimComp and SpriteAnim:
		SpriteAnim.current_animation_changed.connect(_updateAnim)
	
	if BeatComp.specific_orientation == 0:
		orientation = EntityComp.DefaultOrientation
	else:
		orientation = BeatComp.specific_orientation
	scale.x *= orientation
	pivot_offset.x *= orientation
	modulate.a = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _progress_ratio = (value - min_value) / (max_value - min_value)
	modulate.a = lerp(modulate.a, clamp(_progress_ratio*80-0.2,0.0,1.0)/dragopacity, delta*8)
	
