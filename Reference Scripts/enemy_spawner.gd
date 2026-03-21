

@export_category('Spawning Parents')
@export var sprite_parent: Node2D
@export var beat_bar_parent: SubViewport
@export var boss_dm_parent: Control

@export_category('Boss Elements')
@export var boss_sprite: PackedScene
@export var beat_bar: PackedScene
@export var boss_dm: PackedScene


func _ready():
	pressed.connect(_spawn)

func _spawn():
	var sprite: BossSprite = boss_sprite.instantiate()
	var bar: BeatBar = beat_bar.instantiate()
	var dm: BossDM = boss_dm.instantiate()
	
	dm.bar_controller._Set_Beat.connect(bar.timeline._Set_Beat)
	
	sprite_parent.add_child(sprite)
	bar.global_position += Vector2.DOWN * 100
	beat_bar_parent.add_child(bar)
	boss_dm_parent.add_child(dm)
