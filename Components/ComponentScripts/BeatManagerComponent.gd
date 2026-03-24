class_name BeatManagerComponent extends Node


@onready var UndoComp : UndoRedo = UndoRedo.new()

@onready var beat_manager_buttons: HBoxContainer = $"../Window/DebugComponent/Debug Container/BeatManagerButtons"
@onready var HeroContainer = $"../Heroes/Container"
@onready var EnemyContainer = $"../Enemies/Container"
var BeatCompValues: Dictionary = {}
var LowestBeatComp : BeatComponent
var LowestBeatCompValue : float




func _randomize(shift_pressed):
			for EntityComp in HeroContainer.get_children():
					for BeatComp in EntityComp.get_children():
						if BeatComp is BeatComponent:
							_BeatOrder("_randomize", shift_pressed, BeatComp, true)
			for EntityComp in EnemyContainer.get_children(): 
					for BeatComp in EntityComp.get_children():
						if BeatComp is BeatComponent:
							_BeatOrder("_randomize", shift_pressed, BeatComp, true)

func _UndoRedo(shift):
	if shift:
		UndoComp.redo()
	else:
		UndoComp.undo()

func _BeatOrder(function, value, RowBeatComp: BeatComponent, UseValue: bool):
	for EntityComp in HeroContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp == RowBeatComp:
					_BaseOrder(function, value, RowBeatComp, UseValue)
	for EntityComp in EnemyContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp == RowBeatComp:
					_BaseOrder(function, value, RowBeatComp, UseValue)

func _EntityOrder(function, value, RowEntityComp: EntityComponent, UseValue: bool):
	for EntityComp in HeroContainer.get_children():
		if EntityComp == RowEntityComp:
			_BaseOrder(function, value, RowEntityComp, UseValue)
	for EntityComp in EnemyContainer.get_children():
			if EntityComp == RowEntityComp:
				_BaseOrder(function, value, RowEntityComp, UseValue)

func _BaseOrder(function, value, SpecifiedComp, UseValue: bool):
	UndoComp.create_action(str(function,value))
	UndoComp.add_do_method(self._SendOrder.bind(function, value, SpecifiedComp, UseValue))
	UndoComp.add_undo_method(self._SendOrder.bind(str("_undo",function), value, SpecifiedComp, UseValue))
	UndoComp.commit_action()

func _SendOrder(function, value, SpecifiedComp, UseValue: bool):
	var undo_callable = Callable(SpecifiedComp, function)
	if UseValue:
		undo_callable.call(value)
	else:
		undo_callable.call()

func _ready() -> void:
	
	$"../Window/DebugComponent/Debug Container/BeatManagerButtons/Button".pressed.connect(_NextFreeBeat)
	$"../Window/DebugComponent/Debug Container/BeatManagerButtons/Button2".pressed.connect(_NextBeat)
	

func _collect_info():
	for EntityComp in HeroContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp is BeatComponent:
					BeatCompValues[BeatComp] = BeatComp.beat / BeatComp.speedvalue
					if BeatCompValues[BeatComp] <= 0:
						BeatCompValues.erase(BeatComp)
	for EntityComp in EnemyContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp is BeatComponent:
					BeatCompValues[BeatComp] = BeatComp.beat / BeatComp.speedvalue
					if BeatCompValues[BeatComp] <= 0:
						BeatCompValues.erase(BeatComp)
	print(BeatCompValues)

func _FindLowest():
		_collect_info()
		if BeatCompValues != {}:
			LowestBeatCompValue = BeatCompValues.values()[0]
			for BeatComp in BeatCompValues:
				if BeatCompValues[BeatComp] < LowestBeatCompValue:
					LowestBeatCompValue = BeatCompValues[BeatComp]
			LowestBeatComp = BeatCompValues.find_key(LowestBeatCompValue)

func _NextFreeBeat():
	_FindLowest()
	
	if LowestBeatComp is BeatComponent:
		for EntityComp in HeroContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp is BeatComponent:
					_BeatOrder("_modifybeat", -LowestBeatCompValue, BeatComp, true)
		for EntityComp in EnemyContainer.get_children():
			for BeatComp in EntityComp.get_children():
				if BeatComp is BeatComponent:
					_BeatOrder("_modifybeat", -LowestBeatCompValue, BeatComp, true)

func _NextBeat():
	for EntityComp in HeroContainer.get_children():
		for BeatComp in EntityComp.get_children():
			if BeatComp is BeatComponent:
				_BeatOrder("_modifybeat", -1, BeatComp, true)
	for EntityComp in EnemyContainer.get_children():
		for BeatComp in EntityComp.get_children():
			if BeatComp is BeatComponent:
				_BeatOrder("_modifybeat", -1, BeatComp, true)
