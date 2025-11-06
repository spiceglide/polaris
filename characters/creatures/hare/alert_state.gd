extends State

@export var speed = 1000
@export var leap_duration = 12
@export var leap_count = 5
var counter: int = 0;

var anim: AnimationPlayer
var notifications: Control

func enter() -> void:
	notifications = parent.get_node("Notifications")
	anim = parent.get_node("AnimationPlayer")
	if anim:
		anim.play("alert")

func _on_alert_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		parent.data["last_player_pos"] = body.global_position
		state_transitioned.emit(self, "idle")

func _on_danger_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		parent.data["last_player_pos"] = body.global_position
		notifications.announce(tr("ENEMY_HARE_FLEE_1"))
		state_transitioned.emit(self, "flee")
