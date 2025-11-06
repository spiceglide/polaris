extends State

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
		parent.data["last_player_pos"] = body.global_position
		state_transitioned.emit(self, "alert")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name not in ["idle", "idle_earflop"]:
		return
	
	if anim:
		if counter == 0:
			anim.play("idle_earflop")
		else:
			anim.play("idle")
