class_name DebugComponent extends Control

signal pressed
signal pressed2
signal pressed3

@onready var HeroContainer = $"../../Heroes/Container"
@onready var EnemyContainer = $"../../Enemies/Container"
@export var EntityRowScene : PackedScene
@export var BeatCompRowScene : PackedScene
@export var BeatManagerComp : BeatManagerComponent
@export var DebugGUI: Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for EntityComp in HeroContainer.get_children():
		instantiateForEntityComps(EntityComp)
	for EntityComp in EnemyContainer.get_children():
		instantiateForEntityComps(EntityComp)


func instantiateForEntityComps(EntityComp):
	var EntityRow = EntityRowScene.instantiate()
	EntityRow.EntityComp = EntityComp
	DebugGUI.add_child(EntityRow)
	for BeatComp in EntityComp.get_children():
		if BeatComp is BeatComponent:
			var BeatRow = BeatCompRowScene.instantiate()
			BeatRow.BeatComp = BeatComp
			EntityRow.add_child(BeatRow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _buttonpressed(function, value, RowBeatComp):
	print(str(function, value, RowBeatComp))

func _on_test_button_pressed() -> void:
	pressed.emit(1)

func _on_test_button_2_pressed() -> void:
	pressed2.emit(1)

func _on_test_button_3_pressed() -> void:
	pressed3.emit()
