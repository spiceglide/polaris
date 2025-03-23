extends CharacterBody2D

@export var speed = 6000
@export var leap_duration = 12
var state: State = State.Idle
var leap_time = 0
var leap_direction = Vector2.ZERO

enum State {
	Idle,
	Alert,
	Danger,
}

func _ready() -> void:
	$AnimatedSprite2D.animation = "ribbit"
	$AnimatedSprite2D.play()
	
func _process(delta: float) -> void:
	if leap_time > leap_duration:
		finish_leap()
		
	if state == State.Danger:
		print(leap_time)
		if leap_time == 0:
			start_leap()
		else:
			leap_time += 1
	
	print(leap_time)

func _physics_process(delta: float) -> void:
	# Determine direction
	velocity = Vector2.ZERO
	velocity.x += leap_direction.x
	velocity.y += leap_direction.y

	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide()

func set_state(state: State):
	self.state = state
	
	match state:
		State.Idle:
				$AnimatedSprite2D.animation = "ribbit"
		State.Alert:
				$AnimatedSprite2D.animation = "idle"

func start_leap():
	var left_right = randf()
	var up_down = randf()
	
	leap_time = 0
	
	if left_right < 0.5:
		leap_direction.x = 1
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		leap_direction.x = -1
	
	if up_down < 0.33:
		leap_direction.y = 1
	elif up_down < 0.66:
		leap_direction.y = 0
	else:
		leap_direction.y = -1
		
	$AnimatedSprite2D.animation = "leap"
	

func finish_leap():
	leap_direction = Vector2.ZERO
	leap_time = 0

func _on_alert_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		set_state(State.Alert)

func _on_alert_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		set_state(State.Idle)

func _on_danger_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		set_state(State.Danger)

func _on_danger_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		set_state(State.Alert)
