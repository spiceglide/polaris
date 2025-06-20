extends CharacterBody2D

enum State {
	Grounded,
	Midair,
	Walled,
	Squat,
	Slide,
}

@export var jump_height = 600
@export var gravity = 20

var state = State.Grounded
var last_dir = "east";
var jump_velocity = sqrt(2 * jump_height * gravity)
var jump_count = 0
var t = 0

func _process(delta: float) -> void:
	if PlayerData.flags["position_updated"]:
		self.position = PlayerData.position
		PlayerData.flags["position_updated"] = false
	
	match last_dir:
		"east":
			$Sprite.flip_h = false
		"west":
			$Sprite.flip_h = true
	
	PlayerData.position = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if PlayerData.state in [PlayerData.State.Awake, PlayerData.State.Holding]:
		_move()

func _move() -> void:
	# Speed multiplier
	var mult = 0.5
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	# Reset velocities
	velocity.x = 0
	velocity.y += gravity
	
	match state:
		State.Grounded:
			# Determine direction
			if Input.is_action_pressed("move_right"):
				if last_dir == "west":
					$AnimationPlayer.play("slide/descent")
					$AnimationPlayer.queue("slide/ascent")
				$AnimationPlayer.queue("movement/walk")
				
				last_dir = "east"
				velocity.x += 1
			elif Input.is_action_pressed("move_left"):
				if last_dir == "east":
					$AnimationPlayer.play("slide/descent")
					$AnimationPlayer.queue("slide/ascent")
				$AnimationPlayer.queue("movement/walk")
				
				last_dir = "west"
				velocity.x -= 1
			else:
				$AnimationPlayer.queue("idle/idle")
			
			if not is_on_floor():
				state = State.Midair
			
			# Jumping
			if Input.is_action_pressed("move_up"):
				velocity.y = -jump_velocity * 3.5
				jump_count = 1
				$AnimationPlayer.play("jump/ascent")
			
			# Slide & squat
			if Input.is_action_pressed("move_down"):
				if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
					state = State.Slide
					$AnimationPlayer.play("slide/descent")
				else:
					state = State.Squat
					$AnimationPlayer.play("crouch/descent")
		State.Midair:
			# Determine direction
			if Input.is_action_pressed("move_left"):
				last_dir = "west"
				velocity.x -= 1
			if Input.is_action_pressed("move_right"):
				last_dir = "east"
				velocity.x += 1
			
			# Double jump
			if Input.is_action_just_pressed("move_up") and jump_count < 2:
				velocity.y = -jump_velocity * 3
				jump_count += 1
				$AnimationPlayer.play("jump/ascent")
			
			# Jump terminate
			if velocity.y <= 0 and Input.is_action_just_released("move_up"):  # jump terminate
				velocity.y = 0
			
			# Falling
			if velocity.y > 0:
				$AnimationPlayer.play("jump/descent")
			
			# Wall check
			if is_on_wall_only() and velocity.y >= 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
				state = State.Walled
				velocity.y = 0
				$AnimationPlayer.play("wall/slide")
			
			# Landing
			if is_on_floor():
				state = State.Grounded
				$AnimationPlayer.play("jump/landing")
			
			# Diving
			if Input.is_action_pressed("move_down"):
				if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
					state = State.Slide
					$AnimationPlayer.play("slide/descent")
		State.Walled:
			jump_count = 1
			velocity.y /= 1.3
			
			# Check if on wall this and last frame
			if not is_on_wall():
				if t > 0:
					state = State.Grounded
					t = 0
				else:
					t += 1
			else:
				t = 0
			
			# Wall jump
			if (  # Hugging wall
				(Input.is_action_pressed("move_left") and get_wall_normal().x >= 0)
				or (Input.is_action_pressed("move_right") and get_wall_normal().x < 0)
			):
				if Input.is_action_pressed("move_up"):
					state = State.Midair
					velocity.y = -jump_velocity * 3
					$AnimationPlayer.play("wall/prejump")
					$AnimationPlayer.queue("jump/ascent")
			else:  # Not against wall
				if is_on_floor():
					state = State.Grounded
				else:
					state = State.Midair
			
			# Animation
			if is_on_floor():
				state = State.Grounded
				$AnimationPlayer.play("wall/ground")
				$AnimationPlayer.queue("idle/idle")
			else:
				$AnimationPlayer.play("wall/slide")
		State.Squat:
			#Unsquat
			if not Input.is_action_pressed("move_down"):
				state = State.Grounded
				$AnimationPlayer.play("crouch/ascent")
		State.Slide:
			# Set direction
			if last_dir == "west":
				velocity.x -= 1
			if last_dir == "east":
				velocity.x += 1
			
			# Change direction
			if Input.is_action_just_pressed("move_left") and last_dir == "east":
				t = 0
				velocity *= -1
				last_dir = "west"
				$AnimationPlayer.play("slide/descent")
			elif Input.is_action_just_pressed("move_right") and last_dir == "west":
				t = 0
				velocity *= -1
				last_dir = "east"
				$AnimationPlayer.play("slide/descent")
			
			# Friction
			t += 1
			velocity.x /= (t*0.1)
			
			if is_on_wall():
				t = 0
				state = State.Squat
				$AnimationPlayer.play("crouch/descent")
			
			if not Input.is_action_pressed("move_down") and not $AnimationPlayer.is_playing():
				t = 0
				state = State.Grounded
				$AnimationPlayer.play("slide/ascent")
	
	if velocity.length() > 0:
		velocity.x *= PlayerData.speed * mult
		move_and_slide()
