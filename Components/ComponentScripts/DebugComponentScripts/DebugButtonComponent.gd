class_name DebugButtonComponent extends Button

signal _IDPressed

@export var function : String
@export var UseValue : bool = true
@export var value : Variant
@onready var BeatCompRow: HBoxContainer = $".."
@onready var EntityRow: FoldableContainer = $"../../.."
@onready var DebugComp : DebugComponent = $"../../../../.."
@onready var BeatManager: BeatManagerComponent = $"../../../../../../../BeatManagerComponent"

# Called when the node enters the scene tree for the first time.

func _use_signal():
	_IDPressed.emit()


func _on_pressed():
	pass
