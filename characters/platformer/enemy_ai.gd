extends CharacterBody2D

enum State {
	Idle,
	Walking,
	Midair,
}

var state = State.Idle
var speed = 100
var direction = "left"
var gravity = 20

func _process(delta: float) -> void:
	match direction:
		"left":
			$Sprite.flip_h = true
		"right":
			$Sprite.flip_h = false

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	velocity.x = 0
	
	match state:
		State.Idle:
			velocity.y = 0
			
			if direction in ["left", "right"]:
				walk()
			
			# Ungrounded
			if not is_on_floor():
				fall()
		State.Walking:
			velocity.y = 0
			
			# Moving in a direction
			match direction:
				"left":
					velocity.x -= 1
				"right":
					velocity.x += 1
			
			if not is_on_floor():
				fall()
			
			if is_on_wall():
				direction = "left" if get_wall_normal().x < 0 else "right"
				
		State.Midair:
			# Landing
			if is_on_floor():
				land()
	
	if velocity.length() > 0:
		velocity.x *= speed
		move_and_slide()

func walk() -> void:
	state = State.Walking
	$AnimationPlayer.play("movement/walk")

func idle() -> void:
	state = State.Idle
	$AnimationPlayer.queue("idle/idle")

func fall() -> void:
	state = State.Midair
	$AnimationPlayer.play("jump/descent")

func land() -> void:
	state = State.Idle
	$AnimationPlayer.play("jump/landing")
	$AnimationPlayer.queue("idle/idle")
