extends BasicAIComponent

@onready var lucille: EntityComponent = $"../../../../Heroes/Container/Lucille"
@onready var stantis: EntityComponent = $"../../../../Heroes/Container/Stantis"
@onready var agar: EntityComponent = $"../../../../Heroes/Container/Agar"
@onready var bree: EntityComponent = $"../../../../Heroes/Container/Bree"
@onready var lottie: EntityComponent = $"../../../../Heroes/Container/Lottie"
@onready var target: EntityComponent
@onready var animID
@onready var beatamount : float = 10

func on_ready() -> void:
	SpriteComp._PlayerAnim("Stage_1")
	
	MainBeatComp._setabsolutebeat(randi_range(6,10))
	
	animation_player.animation_finished.connect(animationfinish)
	match randi_range(1,5):
		1: target = lucille
		2: target = stantis
		3: target = agar
		4: target = bree
		5: target = lottie
		
		

func on_update(CurrentBeatComp):
	print(CurrentBeatComp.beat)
	if CurrentBeatComp.beat > 5.0:
		SpriteComp._PlayerAnim("Stage_1")
	elif CurrentBeatComp.beat > 4.0:
		SpriteComp._PlayerAnim("Stage_2")
	elif CurrentBeatComp.beat > 3.0:
		SpriteComp._PlayerAnim("Stage_3")
	elif CurrentBeatComp.beat > 2.0:
		SpriteComp._PlayerAnim("Stage_4")
		SpriteComp.look_at(target.global_position+Vector2(150, 150))
		SpriteComp.rotation -= deg_to_rad(180)
	elif CurrentBeatComp.beat <= 0:
		animation_player.play("Attack")
		
		for Beatcomp in target.get_children():
			if Beatcomp is BeatComponent:
				BeatManagerComp._BeatOrder("_drag", 1, Beatcomp, true)

func animationfinish(animFinished):
	match animFinished:
		"Attack":
			get_owner().queue_free()
		"Stage_1":
			SpriteComp._PlayerAnim("Stage_1_Loop")
		"Stage_2":
			SpriteComp._PlayerAnim("Stage_2_Loop")
		"Stage_3":
			SpriteComp._PlayerAnim("Stage_3_Loop")
		"Stage_4":
			SpriteComp._PlayerAnim("Stage_4_Loop")
	
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
