extends State

var anim: AnimationPlayer
var item_sprite: AnimatedSprite2D
var animal_sprite: AnimatedSprite2D
var triggered: bool = false

func enter():
	triggered = false
	anim = parent_body.get_node("AnimationPlayer")
	item_sprite = parent_body.get_node("Sprite/Item")
	animal_sprite = parent_body.get_node("Sprite/Animal")
	anim.play("action/kill_1")
	anim.queue("action/kill_2")

func exit():
	return

func update(delta: float):
	if Input.is_action_just_pressed("use_item") and not triggered:
		anim.play("action/kill_3")
		triggered = true

func physics_update(delta: float):
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "action/kill_3":
		return
	
	parent_body.last_dir = "south"
	state_transitioned.emit(self, "idle")
