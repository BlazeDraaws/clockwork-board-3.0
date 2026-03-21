extends AnimatedSprite2D
#var idle2tween = create_tween()
#var idletween = create_tween()
var free_turn: bool = true
var start_pos = position
var dragtween: Tween
var mat := self.material as ShaderMaterial
var desaturation = 0.0
var drag = 0.0
var phase: int = 1
var Action: String
var currentAct: String
var hat = true
var triple = false
var setTriple = false
var HatVariable: String = "H_"
var Amount: String = "_1"
@onready var pot2: AnimatedSprite2D = $Projectile/Projectile
@onready var pot3: AnimatedSprite2D = $Projectile/Projectile2

@export var colour : Color
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var mat := self.material as ShaderMaterial
	if mat:
		mat.set("shader_parameter/desaturate_strength", 0.0)
	else:
		push_warning("Material is not a ShaderMaterial.")

func _nextbossphase(phase):
	var effect = create_tween()
	match phase:
		1:

			get_tree().call_group("worldfilter","_darkness", 10000)
			get_tree().call_group("worldfilter","_stilldark", 20)
			get_tree().call_group("bg","_dark", 0)
			self.stop()
			self.play("stage 1")
			
		2:
			get_tree().call_group("drag buttons","addDrag", 1)
			get_tree().call_group("worldfilter","_darkness", 10000)
			get_tree().call_group("worldfilter","_stilldark", 50)
			get_tree().call_group("bg","_dark", 0.3)
			self.stop()
			self.play("stage 2")
		3:
			get_tree().call_group("drag buttons","addDrag", 1)
			get_tree().call_group("worldfilter","_darkness", 10000)
			get_tree().call_group("worldfilter","_stilldark", 80)
			get_tree().call_group("bg","_dark", 0.5)
			self.stop()
			self.play("stage 3")
		4:
			get_tree().call_group("drag buttons","addDrag", 1)
			get_tree().call_group("worldfilter","_darkness", 1000)
			get_tree().call_group("worldfilter","_stilldark", 100)
			get_tree().call_group("bg","_dark", 0.7)
			self.stop()
			self.play("stage 4")

func _process(delta: float) -> void:
	if mat:
		mat.set("shader_parameter/desaturate_strength", desaturation)

func _universal_beat_reciever(beat, swinging, is_pull_mode, speed, dragset, notetype, usage, current_group):
	print("[" + current_group + "] _universal_beat_reciever: " + self.name + " recieved Info! ", swinging, is_pull_mode, beat)
	drag = dragset
	var dragtween = create_tween()
	var clamped_drag = clamp(drag, -2,4)
	dragtween.tween_property(self,"desaturation", clamped_drag/4, 5.0)
	
	
	
	var swingtween = create_tween()
	if beat <= 0:
		
		swingtween.set_trans(Tween.TRANS_SINE)
		swingtween.tween_property(self,"rotation_degrees",0, 0.7+drag/5)
		activeanimation()
	else:
		stopactiveanimation()
		if swinging == true:
			swingtween.play()
			swingtween.EASE_OUT
			swingtween.set_trans(Tween.TRANS_SINE)
			if is_pull_mode:
				swingtween.tween_property(self,"rotation_degrees",10, 0.7+drag/5)
			else:
				swingtween.tween_property(self,"rotation_degrees",-10, 0.7+drag/5)
		else:
			swingtween.tween_property(self,"rotation_degrees",0, 0.7+drag/5)

func activeanimation():
	if free_turn:
		free_turn = false
		#idletween.play()
		#idle2tween.play()
		#idletween.tween_property(self,"position",start_pos + Vector2(0,0),1)
		#idle2tween.tween_property(self,"rotation_degrees",0, 2)
		print("_universal_beat_reciever: " + self.name + " playing")

func stopactiveanimation():
	#idletween.pause()
	#idle2tween.pause()
	reset()
	print("_universal_beat_reciever: " + self.name + " pausing")
	free_turn = true

func reset():
	var reset = create_tween()
	reset.EASE_IN_OUT
	reset.parallel().tween_property(self,"position",start_pos + Vector2(0,0),1)
	reset.parallel().tween_property(self,"rotation_degrees",0, 1)
	reset.kill()


func _CustomAction(Action):
	currentAct = Action
	if Action == "Reload":
			_Replenish()
	elif Action == "Triple":
		triple = !triple
		$Projectile2.set_visible(triple)
		$Projectile3.set_visible(triple)
	elif Action == "Hat":
		hat = !hat
	else:
		_DynamicAnim(Action)

func _PlayerAnim(animID): # No hat and Amount 
	if animation != animID:
		play(animID)
		animation_player.play(Action)

func _DynamicAnim(Action):
	if animation != str( HatVariable, Action, Amount ):
		play(str( HatVariable, Action, Amount ))
		animation_player.play(Action)

func _Replenish():
	material.set_shader_parameter("replacement_colour", colour)
	currentAct = "Reload"
	if hat:
		HatVariable = "H_"
	else:
		HatVariable = "N_"
	if triple:
		Amount = "_3"
		
	else:
		Amount = "_1"
	if animation != str( HatVariable, "Reload", Amount ):
		play(str( HatVariable, "Reload", Amount ))
	animation_player.play("Reload")

	
func _on_animation_changed() -> void:
	pass


func _on_animation_finished() -> void:
	print(currentAct)
	match currentAct:
		"Lob":
			pass
		"SpikeReady":
			pass
		"Reload":
			play(str( HatVariable, "Idle", Amount ))
		_:
			_Replenish()


func _KeyOut(Replacement_Colour: Variant) -> void:
	colour = Replacement_Colour
