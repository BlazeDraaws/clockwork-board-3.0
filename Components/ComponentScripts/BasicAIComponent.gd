class_name BasicAIComponent extends Node

@onready var debug_component: DebugComponent = $"../../../../Window/DebugComponent"

@onready var EntityComp : EntityComponent = $".."
@onready var MainBeatComp : BeatComponent = EntityComp.MainBeatComp
@onready var SpriteComp : SpriteComponent = EntityComp.SpriteComp
@onready var BeatManagerComp: BeatManagerComponent = $"../../../../BeatManagerComponent"
@onready var animation_player: AnimationPlayer = $"../SpriteComponent/AnimationPlayer"
@onready var targets : Array
const BeatCompScene = preload("uid://bgjfatmk16mx0")
@onready var lastbeatcomp := MainBeatComp
@onready var Tempo := 10
@onready var NextAction : String
@onready var targetdictionary : Dictionary
@onready var actiondictionary : Dictionary
func _update(_CurrentBeatComp : BeatComponent):
	on_update(_CurrentBeatComp)
	if _CurrentBeatComp:
		if _CurrentBeatComp.beat_history.front() <= 0 and _CurrentBeatComp.beat > 0: # going from 0 to something
			on_ready(_CurrentBeatComp)
			return
		if _CurrentBeatComp.beat_history.front() > 0 and _CurrentBeatComp.beat <= 0:# going from something to 0
			if actiondictionary.get(_CurrentBeatComp):
				if self.has_method(actiondictionary.get(_CurrentBeatComp)):
					_action(actiondictionary.get(_CurrentBeatComp), targetdictionary.get(_CurrentBeatComp))
			on_cast(_CurrentBeatComp)
			return
		if _CurrentBeatComp.beat_history.front() <= 0 and _CurrentBeatComp.beat <= 0: # going from 0 to 0
			on_free(_CurrentBeatComp)
			return
		if _CurrentBeatComp.beat_history.front() > 0 and _CurrentBeatComp.beat > 0: # going from something to something
			on_busy(_CurrentBeatComp)
			return

func _choosetargets(Group : String = "Friendly", Amount : int = 1):
	if Group == "Self":
		targets = [EntityComp]
	elif Group == "All":
		targets = Registry.get_random_entities(Amount)
	else:
		targets = Registry.get_random_from_group(Group, Amount)
	if Amount == 0:
		return null
	else:
		return targets


func _choosetarget(Group : String = "Friendly"):
	if Group == "Self":
		targets = [EntityComp]
	elif Group == "All":
		targets = Registry.get_random_entities(1)
	else:
		targets = Registry.get_random_from_group(Group, 1)
		return targets.get(0)


func _action(action : String, comptargets):
	if comptargets:
		for comptarget in comptargets:
			if is_instance_valid(comptarget):
				call(action, comptarget)
	else:
		call(action, null)

func _next_action(action : String, beats : float, BeatComp : BeatComponent = MainBeatComp):
	actiondictionary.set(BeatComp, action)
	targetdictionary.set(BeatComp, targets)
	SetBeat(beats, BeatComp)

func SetBeat(beats, BeatComp : BeatComponent = MainBeatComp):
	BeatManagerComp._BeatOrder("_setbeat", beats, BeatComp, true)

func _newline(nameplate, beats, secondary = false, carry_over_stats = false):
	
	# summon gui progress bar
	var NewBeatComp : BeatComponent = BeatCompScene.instantiate()
	
	# add its variables, value, name, etc
	NewBeatComp.position.y = MainBeatComp.position.y + 20
	NewBeatComp.position.x = MainBeatComp.position.x 
	NewBeatComp.name = nameplate
	NewBeatComp.Secondary = secondary
	if carry_over_stats: # this might be broken
		NewBeatComp.beat = beats + MainBeatComp.drag
		NewBeatComp.speed = MainBeatComp.speed
	else:
		NewBeatComp.beat = beats
	NewBeatComp.temp = true
	add_sibling(NewBeatComp)
	debug_component.register_beat(NewBeatComp.EntityComp, NewBeatComp)
	return NewBeatComp
func print_game(a, ...args):
	if a is Color:
		args.push_front(str("[color=gray][i] Narration: [/i][/color][color=", a.to_html(false), "][b][center]"))
	else:
		args.push_front(str("[color=gray][i] Narration: [/i][/color][color=white][b][center]", a))
	args.push_back("[/center][/b][/color]")
	var s = ""
	for i in args:
		s += str(i)
	print_rich(str(s))

func name(object):
	if object is Object:
		if object == self:
			return EntityComp.name.to_upper()
		else:
			return object.name.to_upper()
	else:
		return object

func test(testtarget) -> void:
	testtarget.hurt()

# to be used when making ai scripts

func _ready() -> void:
	pass

func on_update(_CurrentBeatComp : BeatComponent):
	pass

func _process(_delta: float) -> void:
	pass

# turn triggers

func on_ready(_beatcomp):
	pass

func on_cast(_beatcomp):
	pass

func on_free(_beatcomp):
	pass

func on_busy(_beatcomp):
	pass

func on_hurt():
	pass
