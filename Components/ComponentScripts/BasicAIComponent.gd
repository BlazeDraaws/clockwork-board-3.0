class_name BasicAIComponent extends Node

@export var EntityComp : EntityComponent 
@onready var MainBeatComp : BeatComponent = EntityComp.MainBeatComp
@onready var SpriteComp : SpriteComponent = EntityComp.SpriteComp
@onready var BeatManagerComp: BeatManagerComponent = $"../../../../BeatManagerComponent"
@onready var animation_player: AnimationPlayer = $"../SpriteComponent/AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for BeatComp in EntityComp.get_children():
		if BeatComp is BeatComponent:
			BeatComp._update.connect(on_update)
	on_ready()

# Called when the node enters the scene tree for the first time.
func on_ready():
	pass

func on_update(_CurrentBeatComp : BeatComponent):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
