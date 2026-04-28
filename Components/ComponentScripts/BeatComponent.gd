class_name BeatComponent extends Node

@export var beat : float = 0
@export var drag : int = 0
@export var speedvalue : float = 1
@export var notetype : int = 1
@export var Secondary : bool = false
@export var line : bool = true
@export var specific_orientation : int = 0
@export var GUIComp : GUIComponent

var temp : bool = false
var prev_beat : float
var orientation : int
var beat_history: Array = []
var speed_history: Array = []
var notetype_history: Array = []
var extrarand_history: Array = []
var drag_history: Array = []
var history_limit:= 30

signal _update
signal _finished

@onready var BeatManagerComp : BeatManagerComponent = $"../../../../BeatManagerComponent"
@onready var UndoComp : UndoRedo = UndoRedo.new()
@onready var EntityComp : EntityComponent = $".."
@export var BackupEntity : EntityComponent
@export var BackupSprite : SpriteComponent

func _ready() -> void:
	if GUIComp:
		GUIComp._addGUI(line)

	
	if EntityComp == null:
		EntityComp = BackupEntity
	
	if specific_orientation == 0:
		orientation = EntityComp.DefaultOrientation
	else:
		orientation = specific_orientation
	
	Registry.register_beat(self)
	await get_tree().process_frame
	Registry.link(get_parent(), self)
	
	self._update.connect(EntityComp.sync) #is synced with entity
	for childcomp in EntityComp.get_children(): #then synced with its siblings
		if childcomp and childcomp.has_method("_update"): 
			self._update.connect(childcomp._update)


func _exit_tree():
	Registry.unregister_beat(self)


#region Functions
func _modifybeat(steps): #progress timeline forward or backwards
	beat += steps * speedvalue
	update()

func _setbeat(setvalue): #set beat value
	beat_history.push_front(beat)
	
	if beat_history.size() > history_limit:
		beat_history.pop_back()
	
	beat = setvalue + drag
	update()


func _setabsolutebeat(setvalue): #set beat value
	beat_history.push_front(beat)
	
	if beat_history.size() > history_limit:
		beat_history.pop_back()
	
	beat = setvalue
	update()


func _speed(setvalue): #set speed value
	speed_history.push_front(speedvalue)
	
	if speed_history.size() > history_limit:
		speed_history.pop_back()
	
	speedvalue = setvalue
	update()

func _drag(steps): #change drag value up or down
	
	drag_history.push_front(drag)
	if drag_history.size() > history_limit:
		drag_history.pop_back()
	
	drag += steps
	update()

func _setdrag(steps): #change drag value up or down
	
	drag_history.push_front(drag)
	if drag_history.size() > history_limit:
		drag_history.pop_back()
	
	drag = steps
	update()

func _notetype(noteID):
	notetype_history.push_front(notetype)
	
	if notetype_history.size() > history_limit:
		notetype_history.pop_back()
	
	notetype = noteID
	update()


func update():
	if beat <= 0:
		_finished.emit()
	
	_update.emit(self) #emit signal to master
	if GUIComp:
		GUIComp._update()
	
	
	if temp and beat <= 0:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _randomize(extra : bool):
	
	extrarand_history.push_front(extra)
	if extrarand_history.size() > history_limit:
		extrarand_history.pop_back()
		
	_setbeat(round(randf_range(1,16)))
	if extra:
		_speed([0.0,0.5,1,2,4].pick_random())
		_drag([-2,-1,0,1,2].pick_random())
		extra = false
#endregion

#region Undo Functions
func _undo_modifybeat(steps): #progress timeline forward or backwards
	beat -= steps * speedvalue
	update()

func _undo_setbeat(_setvalue): #set beat value NOTE: it wont undo if it isnt called from BeatManager
	if beat_history.size() == 0:
		return
	beat = beat_history.pop_front()
	update()

func _undo_speed(_setvalue): #set speed value
	if speed_history.size() == 0:
		return
	speedvalue = speed_history.pop_front()
	update()

func _undo_drag(_steps): #change drag value up or down
	if drag_history.size() == 0:
		return
	drag = drag_history.pop_front()
	update()

func _undo_notetype(_noteID):
	if notetype_history.size() == 0:
		return
	notetype = notetype_history.pop_front()
	update()

func _undoupdate():
	update()

func _undo_randomize(extra : bool):
	if extrarand_history.size() == 0:
		return
	extra = extrarand_history.pop_front()
	_undo_setbeat(randf_range(1,16))
	if extra:
		_undo_speed(1)
		_undo_drag(1)
		extra = false

#endregion
