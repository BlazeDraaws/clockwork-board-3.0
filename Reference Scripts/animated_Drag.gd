extends AnimatedSprite2D

@onready var animated_sprite_2d: AnimatedSprite2D = $"."

var drag: float = 0.0

func _process(delta: float) -> void:
	# Opacity drops from 1.0 (drag = 0) to 0.25 (drag = 3)
	var target_opacity = lerp(0.0, 1.0, drag / 2.0 )
	modulate.a = lerp(modulate.a, target_opacity, delta * 5)  # Smooth transition

func _drag(drag_level):
	print(animated_sprite_2d.animation)
	drag = clamp(drag_level, 0, 2)  # Correctly set the instance variable
	
	if drag_level >= 4:
		if  animated_sprite_2d.animation == "Stage 1":
			stage2()
	else:
		stage1()

func stage1():
	animated_sprite_2d.set_frame(randi_range(1,3)*4 - 4)
	animated_sprite_2d.play("Stage 1")

func stage2():
	animated_sprite_2d.set_frame(randi_range(1,3)*4 - 4)
	animated_sprite_2d.play("Stage 2")
