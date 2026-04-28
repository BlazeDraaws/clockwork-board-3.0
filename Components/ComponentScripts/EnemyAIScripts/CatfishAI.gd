extends BasicAIComponent

@onready var distance := 5.0
@onready var cooldown
@onready var shotguncooldown
@onready var ItemArray
@onready var stagger

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
	if distance <= 0:
		print_game(Color(0.078, 1.0, 0.0, 1.0), "You're dealing real damage now!")
	stagger = _newline("Stagger", 3, true)
	if randi_range(1,3) == 2:
		print_game(Color(0.895, 0.871, 0.304, 1.0), "has been critically hit! They are staggered for 3 beats!")
		BeatManagerComp._BeatOrder("_speed",0,MainBeatComp,true)
	else:
		print_game(Color(0.895, 0.871, 0.304, 1.0), "has been critically hit! They are slowed for 3 beats!")
		BeatManagerComp._BeatOrder("_speed",0.5,MainBeatComp,true)
	await stagger._finished
	BeatManagerComp._BeatOrder("_speed",1,MainBeatComp,true)

func cancelturn():
	_next_action("donothing", 0.5)

func donothing(_comptarget):
	print_game(name(self), " turn was cancelled!")
	pass


func take_turn():
	if distance < 1 and BeatManagerComp._GetComboGroup("Friendly").size() < 2  and !shotguncooldown:
		targets = [BeatManagerComp._GetComboGroup("Friendly").pick_random()]
		print_game("[i]", name(self), ": \"Don't get any closer!\"", "[/i]")
		print_game(name(self), " Shoots his shotgun at ", name(Registry.get_entity(targets.get(0))))
		_next_action("ShotgunShot", 0.5)
		return
	if BeatManagerComp._GetComboGroup("Friendly").size() >= 2 and !cooldown:
		targets = [BeatManagerComp._GetComboGroup("Friendly").pick_random()]
		print_game("[i]", name(self), ": \"Oh no, you don't!\"", "[/i]")
		print_game(name(self), " aims his rifle at ", name(Registry.get_entity(targets.get(0))))
		_next_action("DisruptCombo", 2)
	else:
		match randi_range(1,5):
			1: #shoot someone
				if cooldown:
					return
				var target = _choosetarget()
				print_game(name(self), " aims his rifle at ", name(target))
				_next_action("RifleShot", 1)
			2:
				if distance > 2:
					print_game(name(self), " looks for something to use!")
					ItemArray = PickItem()
					_choosetargets("Friendly", ItemArray.get(1))
					_next_action("UseItem", 2)
				else:
					print_game(name(self), " is clearing out his stock!")
					_next_action("UseItemHectic", 4)
			3:
				if distance > 2:
					print_game(name(self), " looks for something to use!")
					ItemArray = PickItem()
					_choosetargets("Friendly", ItemArray.get(1))
					_next_action("UseItem", 2)
				else:
					print_game(name(self), " is clearing out his stock!")
					_next_action("UseItemHectic", 4)
			4:
				if distance > 2:
					print_game(name(self), " looks for something to use!")
					ItemArray = PickItem()
					_choosetargets("Friendly", ItemArray.get(1))
					_next_action("UseItem", 2)
				else:
					print_game(name(self), " is clearing out his stock!")
					_next_action("UseItemHectic", 4)
			5: #taunt
				_choosetarget()
				_next_action("taunt", 1)
				print_game(Color(1.0, 1.0, 1.0, 1.0), name(self), " starts laughing!")

func DisruptCombo(comptarget):
	if BeatManagerComp._GetComboGroup("Friendly").has(comptarget):
		print_game(Color.RED, name(self), " shot ", name(comptarget.EntityComp), " for disrupted their attack!")
		BeatManagerComp._BeatOrder("_modifybeat",1,comptarget,true)
		comptarget.EntityComp.hurt()
	else:
		print_game("[i]", name(self), ": \"Damn it! I missed!\"", "[/i]")
		cooldown = _newline("RifleCooldown", 2, true)

func RifleShot(comptarget): 
	print_game(Color.RED, name(self), " shot ", name(comptarget), " for ", randi_range(6,10)*5, " Damage!")
	cooldown = _newline("Rifle Cooldown", 3, true)
	comptarget.hurt()

func ShotgunShot(comptarget): 
	print_game(Color.RED, name(self), " shotgunned ", name(comptarget), " for ", randi_range(6,10)*5, " Damage!")
	shotguncooldown = _newline("Shotgun Cooldown", 4, true)
	BeatManagerComp._BeatOrder("_modifybeat",1,comptarget,true)
	
	comptarget.EntityComp.hurt()

func PickItem():
	match randi_range(1, 15):
		1: return ["SmokeBombs", randi_range(1, 3), str(" confusing them for ", randi_range(7,10), " beats!")]
		2: return ["Explosive", randi_range(3,4), str(" dealing ", randi_range(4,8)*5, " damage!")]
		3: return ["Cannon", 1, str(" dealing half their health if they fail AGILITY CHECK of ", randi_range(1,20), "!")]
		4: return ["Jellyfish", randi_range(1, 2), str(" pushing ", randi_range(1,3), " beats!")]
		5: return ["FirePot", randi_range(1, 2), str(" dealing ", randi_range(4,8)*5, " damage!")]
		6: return ["IcePot", randi_range(1, 2), str(" slowing them down for ", randi_range(1,3), " beats!")]
		7: return ["GrowthPot", randi_range(1, 2), str(" stunning them! it will take a STRENGTH CHECK of ", randi_range(1,25), " to get rid of!")]
		8: return ["RotPot", randi_range(1, 2), " recieving +1 drag!"]
		_: return ["RandomStuff", randi_range(0, 4), str(" dealing ", randi_range(1,20)*5, " damage!")]

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
