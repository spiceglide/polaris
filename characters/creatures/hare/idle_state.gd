extends State

@export var speed = 1000
@export var leap_duration = 12
@export var leap_count = 5

var anim: AnimationPlayer
var counter: int = 0;

func enter() -> void:
	anim = parent.get_node("AnimationPlayer")
	if anim:
		anim.play("idle")

func _process(delta: float) -> void:
	counter = int(counter + delta*1000) % 4

func _on_alert_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		parent.data["last_player_pos"] = body.position
		state_transitioned.emit(self, "alert")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.substr(0, 4) == "idle":
		if anim:
			if counter == 0:
				anim.play("idle_earflop")
			else:
				anim.play("idle")
