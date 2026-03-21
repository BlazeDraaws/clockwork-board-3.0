extends TextureProgressBar

signal _update_number(real_value, current_group, speed)
signal _PlayerAnim(animID)
var last_speed = value
var next_value = value 
var real_value = value 
var has_chimed = false
var color_base: Color
@export var orientation: float = Orientation.PLAYER
@export var drag: float = 0.00  # Each point of drag slows beats and darkens UI
@export var speed = 1.0  # Each point of drag slows beats and darkens UI
@export var swinging = false
var yellow = false
var last_real_value = 0  # Store the last known value
@export var usage = false
enum Orientation {PLAYER = 1, ENEMY = -1}
@onready var progress_icon = $"Note" 
@export var icon_offset: float = 0.0
var notetype:int = 1
var NORMAL_BEAT_DECAY = 1

# unused
var is_pull_mode = 0


func _updatenotetype(ntype):
	notetype = ntype

func _drag(dragset):
	drag = dragset

func _ready() -> void:
	self_modulate = Color(1, 1, 1, 1 - drag/3)
	pass

func _Next_Beat(beats_to_skip):
	print("nextbeat: skipped ",beats_to_skip," beats! ")
	if usage:
		real_value = max(0.0, real_value - beats_to_skip*10*speed)
		next_value = real_value
		if next_value == 0:
			_PlayerAnim.emit("Cast")

func _Prev_Beat():
	if  usage == true:
		# Debug
		print("Understood!")
		print("Real Value:", real_value)

		real_value = max(0.0, real_value + 10)  # Clamp real_value to minimum 0 (it doesnt actually do shit btw)
		next_value = real_value

func _toggle_speed(_speedsubmitted):
	speed = _speedsubmitted
	print("speed is: ", speed)
	get_tree().call_group("Speed Buttons", "_compare", speed)
	if speed > 1:
		# FAST
		_tint_node(self, Color(0, 1, 1))
	
		if yellow:
			# SWIMG FAST
			_tint_node(self,Color(0, 1, 1) * Color(1, 0.9, 0.5))
	elif speed < 1:
		# SLOW
		_tint_node(self,Color(1, 0.1, 0.3))
		if yellow:
			# SWING SLOW
			_tint_node(self, Color(1, 0.5, 0))
	else:
		# FROM SPEED CHANGED TO NORMAL
		_reset_tint(self)
		if yellow:
			# Yellow RGB = (1, 1, 0)
			_tint_node(self,color_base * Color(1, 0.9, 0.5))

func _tint_node(node: Node, color: Color) -> void:
	
	if node is CanvasItem:
		(node as CanvasItem).modulate = color
		color_base = color 

	for child in node.get_children():
		_tint_node(child, color)

func _reset_tint(node: Node) -> void:
	_tint_node(node, Color(1, 1, 1))  # White = no tint



func _process(delta: float) -> void:
	
	var drag_clamped = clamp(drag, 0, 3)
	var target_opacity = lerp(1.0, 0.10, drag_clamped / 3.5)
	modulate.a = lerp(modulate.a, target_opacity, delta * 5)  # Smooth transition
	
	# lerping my peantis()
	value = lerp(value, next_value, delta * 3)
	
	if real_value != last_real_value or speed != last_speed:
		_update_number.emit(real_value/10, self.name, speed)
		last_real_value = real_value  # Update to the new value
		last_speed = speed 

	if real_value == 0:
		# Fade out to 0 alpha
		progress_icon.modulate.a = lerp(progress_icon.modulate.a, 0.0, delta * 3)
	else:
		# Fade back to full alpha
		progress_icon.modulate.a = lerp(progress_icon.modulate.a, 1.0, delta * 10)
	
	if progress_icon:
		var global_rect = get_global_rect()

		# Progress 0.0 - 1.0
		var progress_ratio = (value - min_value) / (max_value - min_value)

		# Calculate the X position
		var icon_x = global_rect.position.x + (progress_ratio * global_rect.size.x + icon_offset)*orientation

		# Only move the X! Keep the original Y
		progress_icon.global_position.x = icon_x
		

func _used(usebool):
	usage = usebool
	print(usage)

func _Set_Beat(number_value):
	if  usage == true:
		if real_value <= 0:
			has_chimed = false
		real_value = number_value+drag*10
		next_value = number_value+drag*10
		_PlayerAnim.emit("Ready")
	else:
		
		next_value = 0.0
		real_value = 0.0
		_update_number.emit(real_value/10, self.name, speed)
