extends State

@export var speed = 1000
@export var leap_duration = 12
@export var leap_count = 5

var notifications: Control
var anim: AnimationPlayer

var speech_time = 0
var leap_direction = Vector2.ZERO
var endangered: bool = true

func enter() -> void:
	anim = parent.get_node("AnimationPlayer")
	notifications = parent.get_node("Notifications")
	endangered = true
	start_leap()

func exit() -> void:
	parent.velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	# Determine direction
	parent.velocity = leap_direction

	# Normalise velocity
	if parent.velocity.length() > 0:
		parent.velocity = parent.velocity.normalized() * speed
		parent.move_and_slide()

func start_leap():
	var threat_direction = parent.global_position.direction_to(parent.data["last_player_pos"])
	
	if threat_direction.x < 0:
		leap_direction.x = 1
		anim.play("hop_right")
	else:
		leap_direction.x = -1
		anim.play("hop_left")

	var up_down = randf()
	if up_down < 0.33:
		leap_direction.y = 1
	elif up_down < 0.66:
		leap_direction.y = 0
	else:
		leap_direction.y = -1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name not in ["hop_left", "hop_right"]:
		return
	
	leap_direction = Vector2.ZERO
	if endangered:
		start_leap()
	else:
		state_transitioned.emit(self, "idle")

func _on_alert_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		parent.data["last_player_pos"] = body.global_position
		endangered = false
