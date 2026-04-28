extends BasicAIComponent

@onready var catfish: EntityComponent = $"../../Catfish"


var earthquake
func _ready() -> void:
	pass

func on_update(_CurrentBeatComp : BeatComponent):
	pass

func _process(_delta: float) -> void:
	pass

func on_cast(_beatcomp):
	match randi_range(1,3):
		1:
			await get_tree().create_timer(0.7).timeout
			on_free(_beatcomp)

func on_free(_beatcomp):
	take_turn()

func on_busy(_CurrentBeatComp):
	pass

func on_hurt():
	if catfish.AI.distance <= 0:
		print_game(Color(0.078, 1.0, 0.0, 1.0), "You're dealing real damage now!")
	print_game(Color(0.895, 0.871, 0.304, 1.0), "The Enemies lost some distance!")
	catfish.AI.distance -= 0.5
	print_game("Current Distance: ", catfish.AI.distance*10)

func take_turn():
	if BeatManagerComp._GetComboGroup("Friendly").size() > 0:
		var lowestfriend : BeatComponent = BeatManagerComp._GetComboGroup("Friendly").get(0)
		if lowestfriend.beat > 5:
			_choosetarget()
			print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " uses this free time to start gaining more ground!")
			_next_action("runaway", 4)
			return

		match randi_range(1,3):
			1: #AOE attack
				_choosetargets("Friendly", randi_range(3,4))
				_next_action("Smash", 5)
				print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " jumps up high in the air!")
			2: #Earthquake
				var comptargete = _choosetarget("Friendly")
				_next_action("Earthquake", 5)
				print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " summons an earthquake to hit ", name(comptargete), "! You will have to dodge it!")
			3: #gain distance
				_choosetarget()
				_next_action("runback", 3)
				print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " attempts to run back!")
			4: #freakout
				_choosetarget()
				_next_action("freakout", 2)
				print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " is freaking out!")
	pass

func on_undohurt(_beatcomp):
	runback(_beatcomp)

func runaway(_beatcomp):
	print_game(name(self), " used the opening and ran ahead! +", 3*10, " meters!")
	catfish.AI.distance += 3 
	print_game("Current Distance: ", catfish.AI.distance*10)

func runback(_beatcomp, ..._arg):
	print_game(name(self), " is gaining ground! +", 1*10, " meters!")
	catfish.AI.distance += 1 
	print_game("Current Distance: ", catfish.AI.distance*10)

func Smash(comptarget):
	print_game(Color(0.876, 0.277, 1.0, 1.0), name(self), " smashed down and hit ", name(comptarget), " for ", randi_range(10,15)*5, " Damage!")

func Earthquake(comptarget):
	print_game(Color(0.876, 0.277, 1.0, 1.0), "An Earthquake will hit ", name(comptarget), " for ", randi_range(15,20)*5, " Damage unless they dodge it!")

func freakout():
	print_game(name(self), " is scuttling wildly!")
