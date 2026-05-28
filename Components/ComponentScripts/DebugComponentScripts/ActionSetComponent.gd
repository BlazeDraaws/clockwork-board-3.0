class_name ActionSetComponent extends Node
@onready var main: BeatComponent = $"../Main"
@onready var entity: EntityComponent = $".."
@onready var manager: BeatManagerComponent = $"../../../../BeatManagerComponent"

@export_category("Actions / Abilities")
@export var moves: Array[Action]
@onready var button: Button = $Button
var queue: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func Cast(action: Action):
	var beatcomp = null
	if action.main:
		beatcomp = main
	else:
		beatcomp = entity._newline(action.name, 0.01, true)
		manager._BeatOrder("_setbeat", action.Beat_Cost, beatcomp, true)
		await beatcomp.finished
		print_game(entity.name, " ", action.Narration)
		return
	
	if beatcomp.free:
		queue.append(action)
		await _process_queue(beatcomp)
	else:
		queue.append(action)

func _process_queue(beatcomp):
	while beatcomp.free and not queue.is_empty():
		var current_action = queue.pop_front()
		manager._BeatOrder("_setbeat", current_action.Beat_Cost, beatcomp, true)
		await beatcomp.finished
		print_game(entity.name, " ", current_action.Narration)
		await beatcomp.GUIfinished



func _on_button_pressed() -> void:
	Cast(moves[randi_range(0,2)])
