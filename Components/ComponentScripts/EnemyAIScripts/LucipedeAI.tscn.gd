extends BasicAIComponent

@onready var hp := 100.0
@onready var cooldown
@onready var shotguncooldown
@onready var ItemArray
@onready var stagger
const ENEMY_ROTFISH = preload("uid://bancyvpk77p1b")

func _ready() -> void:
	pass

func on_update(_CurrentBeatComp : BeatComponent):
	pass

func _process(_delta: float) -> void:
	pass

func on_ready(_beatcomp):
	pass

func on_cast(_beatcomp):
	if _beatcomp == MainBeatComp:
		match randi_range(1,2):
			1:
				await get_tree().create_timer(0.7).timeout
				on_free(_beatcomp)

func on_free(_beatcomp):
	match _beatcomp:
		MainBeatComp: take_turn()
		_: pass

func on_busy(_beatcomp):
	pass

func on_hurt():
	if hp <= 0:
		print_game(Color(0.078, 1.0, 0.0, 1.0), "You're dealing real damage now!")
		stagger = _newline("Stagger", 5, true)
		print_game(Color(0.895, 0.871, 0.304, 1.0), "has been critically hit! They are staggered for 5 beats!")
		BeatManagerComp._BeatOrder("_speed",0,MainBeatComp,true)
		await stagger._finished
		BeatManagerComp._BeatOrder("_speed",1,MainBeatComp,true)
		hp += 150
	else:
		hp -= 10
		print_game(Color(0.078, 1.0, 0.0, 1.0), "It has been hurt! Shield at: ", hp,"%")

func cancelturn():
	_next_action("donothing", 0.5)

func donothing(_comptarget):
	print_game(name(self), " skips its turn!")
	pass


func take_turn():
	if BeatManagerComp._GetComboGroup("Friendly").size() >= 2 and !cooldown:
		targets = [BeatManagerComp._GetComboGroup("Friendly").pick_random()]
		print_game("[i]", name(self), ": \"Yes! Feed me your HARMONY\"", "[/i]")
		print_game(name(self), " aims his rifle at ", name(Registry.get_entity(targets.get(0))))
		_next_action("DisruptCombo", 2)
	else:
		match randi_range(1,6):
			1: #shoot someone
				var target = _choosetarget()
				print_game(name(self), " targets ", name(target))
				_next_action("RifleShot", 2)
			2: #shoot someone
				var target = _choosetarget()
				print_game(name(self), " targets ", name(target))
				_next_action("RifleShot", 2)
			3:
				print_game(name(self), " summons rotfish!")
				_next_action("rotfish", 3)
			4:
				print_game(name(self), "'s gears are whirring!")
				_next_action("UseItemHectic", 4)
			5:
				print_game(name(self), "'s gears are whirring!")
				_next_action("UseItemHectic", 4)
			_:
				print_game(name(self), " is doing a lore action!")
				_next_action("donothing", 1)

func DisruptCombo(comptarget):
	if BeatManagerComp._GetComboGroup("Friendly").has(comptarget):
		print_game(Color.RED, name(self), " shot ", name(comptarget.EntityComp), " for disrupted their attack!")
		BeatManagerComp._BeatOrder("_modifybeat",1,comptarget,true)
		comptarget.EntityComp.hurt()
	else:
		print_game("[i]", name(self), ": \"Damn it! I missed!\"", "[/i]")
		cooldown = _newline("RifleCooldown", 2, true)

func RifleShot(comptarget): 
	print_game(Color.RED, name(self), " attacks ", name(comptarget), " for ", randi_range(8,15)*7, " Damage!")
	cooldown = _newline("Rifle Cooldown", 3, true)
	comptarget.hurt()

func ShotgunShot(comptarget): 
	print_game(Color.RED, name(self), " bites ", name(comptarget), " for ", randi_range(6,10)*5, " Damage!")
	shotguncooldown = _newline("Shotgun Cooldown", 4, true)
	BeatManagerComp._BeatOrder("_modifybeat",1,comptarget,true)
	
	comptarget.EntityComp.hurt()

func PickItem():
	match randi_range(1, 9):
		1: return ["Burrow", randi_range(1, 3), str(" confusing them for ", randi_range(7,10), " beats if they fail WISDOM CHECK of ", randi_range(5,15), "!")]
		2: return ["Explosive", randi_range(3,4), str(" dealing ", randi_range(4,8)*10, " damage!")]
		3: return ["Sawblades", 1, str(" dealing half their health if they fail AGILITY CHECK of ", randi_range(5,15), "!")]
		4: return ["Electrocute", randi_range(1, 2), str(" pushing them ", randi_range(1,3), " beats!")]
		5: return ["Gasoline", randi_range(1, 2), str(" dealing ", randi_range(4,8)*15, " damage!")]
		6: return ["Scare", randi_range(1, 2), str(" slowing them down for ", randi_range(1,3), " beats if they fail WISDOM CHECK of ", randi_range(5,15), "!")]
		7: return ["Flash", randi_range(1, 2), str(" stunning them! it will take a STRENGTH CHECK of ", randi_range(1,25), " to get rid of!")]
		8: return ["RotVenom", randi_range(1, 2), " recieving +1 drag if they fail COURAGE CHECK!"]
		_: return ["Writhes Around", randi_range(0, 4), str(" dealing ", randi_range(1,20)*5, " damage!")]

func UseItem(comptarget):
	if comptarget:
		print_game(Color.RED, name(self), " uses ", ItemArray.get(0), " and hits ", name(comptarget), ItemArray.get(2))
		comptarget.hurt()
	else:
		print_game(Color.RED, name(self), " uses ", ItemArray.get(0), " and misses completely!")

func UseItemHectic(_target):
	ItemArray = PickItem()
	var comptargets = _choosetargets("Friendly", ItemArray.get(1))
	if comptargets:
		for comptarget in comptargets:
			print_game(Color.RED, name(self), " uses ", ItemArray.get(0), " and hits ", name(comptarget), ItemArray.get(2))
			comptarget.hurt()
	else:
		print_game(Color.RED, name(self), " uses ", ItemArray.get(0), " and misses completely!")

func taunt(_target):
	print_game(name(self), " taunts at ", name(_target))

func rotfish(_target):
	print_game(name(self), " rotfish is summoned!")
	BeatManagerComp.spawn_entity(ENEMY_ROTFISH)
	
