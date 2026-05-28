extends VBoxContainer
@onready var grid_container: GridContainer = $GridContainer


var EntityComp : EntityComponent
var ActionsComp : ActionSetComponent

func _ready() -> void:
	for action in ActionsComp.moves:
		var btn := Button.new()
		btn.text = action.name
		
		# Store the action on the button
		btn.set_meta("action", action)
		
		# Connect pressed signal
		btn.pressed.connect(_on_action_pressed.bind(btn))
		
		btn.custom_minimum_size.x = 200
		
		grid_container.add_child(btn)

func _on_action_pressed(btn: Button) -> void:
	var action = btn.get_meta("action")
	ActionsComp.Cast(action)
