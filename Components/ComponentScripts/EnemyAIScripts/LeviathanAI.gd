extends BasicAIComponent

@onready var lucille: EntityComponent = $"../../../../Heroes/Container/Lucille"
@onready var stantis: EntityComponent = $"../../../../Heroes/Container/Stantis"
@onready var agar: EntityComponent = $"../../../../Heroes/Container/Agar"
@onready var bree: EntityComponent = $"../../../../Heroes/Container/Bree"
@onready var lottie: EntityComponent = $"../../../../Heroes/Container/Lottie"
@onready var target: EntityComponent
@onready var animID
@onready var container: Node2D = $Enemies/Container
@onready var beatamount
@onready var beat_component_2: BeatComponent = $"../BeatComponent2"

const ENEMY_ROTFISH = preload("uid://bancyvpk77p1b")

func on_ready() -> void:
	select_target()
	
	animation_player.animation_finished.connect(kill)

		
		

func select_target():
	match randi_range(1,5):
		1: target = lucille
		2: target = stantis
		3: target = agar
		4: target = bree
		5: target = lottie

func set_beats():
	for Beatcomp in EntityComp.get_children():
		if Beatcomp is BeatComponent:
			BeatManagerComp._BeatOrder("_setbeat", randi_range(8,12), Beatcomp, true)

func on_update(CurrentBeatComp):
	if CurrentBeatComp.beat <= 0:
		BeatManagerComp._BeatOrder("_setbeat", randi_range(8,12), CurrentBeatComp, true)
		match CurrentBeatComp:
			MainBeatComp:
				action()

			beat_component_2:
				BeatManagerComp.spawn_entity(ENEMY_ROTFISH, container)
				BeatManagerComp.spawn_entity(ENEMY_ROTFISH, container)
				BeatManagerComp.spawn_entity(ENEMY_ROTFISH, container)

func action():
	match randi_range(1,5):
		1: # batch damage + late
			print(randi_range(1,4)*5, " damage to all ")
			BeatManagerComp._BatchBeatModify(2)
			target.hurt()
		2: # damage to 1 + late
			print(randi_range(3,5)*10, " damage to ", target)
			for Beatcomp in target.get_children():
				if Beatcomp is BeatComponent:
					BeatManagerComp._BeatOrder("_modifybeat", randi_range(1,4), Beatcomp, true)
					target.hurt()
		3: #damage to all 
			print(randi_range(1,4)*10, " damage to all ")
			for entity in target.get_parent().get_children():
				entity.hurt()
		4: #damage to 2 people
			print("blindness!")
		5: 
			print("Again!")
			action()

func kill(pluh):
	if pluh == "Attack":
			get_owner().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
