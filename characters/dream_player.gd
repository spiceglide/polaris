extends CharacterBody2D

enum State {
	Idle,
	Walking,
	Pushing,
	Midair,
	Walled,
	Squat,
	Slide,
	Dash,
}

@export var jump_height = 600
@export var gravity = 20

var state = State.Idle
var last_dir = "east";
var jump_velocity = sqrt(2 * jump_height * gravity)
var jump_count = 0
var dash_count = 0
var running_time = 0
var t = 0

var jump_buffered = false

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
		State.Idle:
			last_dir = "idle"
			jump_count = 0
			dash_count = 0
			running_time = 0
			
			# Determine direction
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				state = State.Walking
				$AnimationPlayer.play("movement/walk")
			
			# Ungrounded
			if not is_on_floor():
				state = State.Midair
			
			# Jumping
			if Input.is_action_just_pressed("move_up") or jump_buffered:
				velocity.y = -jump_velocity * 3.5
				$AnimationPlayer.play("jump/ascent")
			
			# Squat
			if Input.is_action_pressed("move_down"):
				state = State.Squat
				$AnimationPlayer.play("crouch/descent")
		State.Walking:
			velocity.y = 0
			running_time += 1
			
			# Determine direction
			if Input.is_action_pressed("move_right"):
				if last_dir == "west":
					if running_time > 30:
						t = 20
						$AnimationPlayer.play("slide/descent")
					running_time = 0
				
				# Wall pushing
				if is_on_wall() and get_wall_normal().x < 0:
					state = State.Pushing
					$AnimationPlayer.play("movement/push")
				
				last_dir = "east"
				velocity.x += 1
				
				# Turning momentum
				if t > 1:
					velocity.x -= 2.0 - (1.0 / (t-1))
					t -= 1
				elif t == 1:
					t -= 1
					$AnimationPlayer.play("slide/ascent")
					$AnimationPlayer.queue("movement/walk")
				
				$StopMovingTimer.stop()
			elif Input.is_action_pressed("move_left"):
				if last_dir == "east":
					if running_time > 30:
						t = 20
						$AnimationPlayer.play("slide/descent")
					running_time = 0
					
				if is_on_wall() and get_wall_normal().x >= 0:
					state = State.Pushing
					$AnimationPlayer.play("movement/push")
				
				last_dir = "west"
				velocity.x -= 1
				
				# Turning momentum
				if t > 1:
					velocity.x += 2.0 - (1.0 / (t-1))
					t -= 1
				elif t == 1:
					t -= 1
					$AnimationPlayer.play("slide/ascent")
					$AnimationPlayer.queue("movement/walk")
				
				$StopMovingTimer.stop()
			else:
				if $StopMovingTimer.is_stopped():
					$StopMovingTimer.start()
			
			# Ungrounded
			if not is_on_floor():
				if $CoyoteTimer.is_stopped():
					$CoyoteTimer.start()
			
			# Jumping
			if Input.is_action_just_pressed("move_up") or jump_buffered:
				state = State.Midair
				velocity.y = -jump_velocity * 3.5
				$AnimationPlayer.play("jump/ascent")
			
			# Slide
			if Input.is_action_pressed("move_down"):
				state = State.Slide
				$AnimationPlayer.play("slide/descent")
		State.Pushing:
			velocity.y = 0
			running_time = 0
			
			var is_hugging_wall = (Input.is_action_pressed("move_left") and get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and get_wall_normal().x < 0)
			var is_opposing_wall = not is_hugging_wall and ((Input.is_action_pressed("move_left") and not get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and not get_wall_normal().x < 0))
			
			# Stop pushing
			if not is_hugging_wall:
				if is_opposing_wall:
					state = State.Walking
					$AnimationPlayer.play("movement/walk")
				else:
					state = State.Idle
					$AnimationPlayer.play("idle/idle")
				
			# Jumping
			if Input.is_action_just_pressed("move_up"):
				state = State.Midair
				velocity.y = -jump_velocity * 3.5
				jump_count = 1
				$AnimationPlayer.play("jump/ascent")
		State.Midair:
			running_time += 1
			
			# Determine direction
			if Input.is_action_pressed("move_left"):
				last_dir = "west"
				velocity.x -= 1
			if Input.is_action_pressed("move_right"):
				last_dir = "east"
				velocity.x += 1
			
			# Double jump
			if Input.is_action_just_pressed("move_up"):
				if jump_count < 1:
					velocity.y = -jump_velocity * 3
					jump_count += 1
					$AnimationPlayer.play("jump/ascent")
				else:  # Jump buffering
					jump_buffered = true
					$JumpBufferTimer.start()
			
			# Jump terminate
			if velocity.y <= 0 and Input.is_action_just_released("move_up"):  # jump terminate
				velocity.y = 0
			
			# Falling
			if velocity.y > 0:
				$AnimationPlayer.play("jump/descent")
			
			# Jump buffering
			if Input.is_action_just_pressed("move_up"):
				jump_buffered = true
				$JumpBufferTimer.start()
			
			# Wall check
			if is_on_wall_only() and velocity.y >= 0 and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
				state = State.Walled
				velocity.y = 0
				$AnimationPlayer.play("wall/slide")
			
			# Landing
			if is_on_floor():
				state = State.Idle
				$AnimationPlayer.play("jump/landing")
				$AnimationPlayer.queue("idle/idle")
			
			# Dash
			if Input.is_action_pressed("move_down") and dash_count < 2:
				dash_count += 1
				state = State.Dash
				$AnimationPlayer.play("dash/overshoot")
				$AnimationPlayer.queue("dash/dash")
		State.Walled:
			velocity.y /= 1.3
			running_time = 0
			
			var is_hugging_wall = (Input.is_action_pressed("move_left") and get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and get_wall_normal().x < 0)
			var is_opposing_wall = (Input.is_action_pressed("move_left") and not get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and not get_wall_normal().x < 0)
			
			# Wall jump
			if Input.is_action_pressed("move_up") and is_opposing_wall:
				state = State.Midair
				velocity.y = -jump_velocity * 2.5
				velocity
				$AnimationPlayer.play("wall/prejump")
				$AnimationPlayer.queue("jump/ascent")
			
			# Release wall delay
			if not is_hugging_wall:
				if $WallJumpTimer.is_stopped():
					$WallJumpTimer.start()
			elif not is_on_wall():
				if $WallJumpTimer.is_stopped():
					$WallJumpTimer.start(0.02)
			else:
				$WallJumpTimer.stop()
			
			# Animation
			if is_on_floor():
				state = State.Idle
				$AnimationPlayer.play("wall/ground")
				$AnimationPlayer.queue("idle/idle")
		State.Squat:
			running_time = 0
			
			#Unsquat
			if not Input.is_action_pressed("move_down"):
				state = State.Idle
				$AnimationPlayer.play("crouch/ascent")
				$AnimationPlayer.queue("idle/idle")
		State.Slide:
			running_time += 1
			
			# Set direction
			if last_dir == "west":
				velocity.x -= 1
			if last_dir == "east":
				velocity.x += 1
			
			# Slide timer
			if $DashTimer.is_stopped():
				$DashTimer.start(0.4)
			
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
			velocity.x *= 8.0/t
			
			if is_on_wall():
				t = 0
				state = State.Squat
				$AnimationPlayer.queue("crouch/descent")
		State.Dash:
			velocity.y = 0
			running_time = 0
			
			# Dash timer
			if $DashTimer.is_stopped():
				$DashTimer.start(0.7)
			
			# Set direction
			if last_dir == "west":
				velocity.x -= 1
			if last_dir == "east":
				velocity.x += 1
			
			# Friction
			t += 1
			velocity.x *= 8.0/t
			
			if is_on_wall():
				t = 0
				state = State.Walled
				$AnimationPlayer.play("wall/slide")
			if is_on_floor():
				t = 0
				state = State.Squat
				$AnimationPlayer.play("crouch/descent")
	
	if velocity.length() > 0:
		velocity.x *= PlayerData.speed * mult
		move_and_slide()

func _on_coyote_timer_timeout() -> void:
	state = State.Midair


func _on_wall_jump_timer_timeout() -> void:
	if is_on_floor():
		state = State.Idle
		$AnimationPlayer.queue("movement/push")
	else:
		state = State.Midair
		$AnimationPlayer.queue("jump/descent")


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false

func _on_dash_timer_timeout() -> void:
	match state:
		State.Dash:
			t = 0
			state = State.Midair
			$AnimationPlayer.queue("jump/descent")
		State.Slide:
			t = 0
			state = State.Walking
			$AnimationPlayer.play("slide/ascent")
			$AnimationPlayer.queue("movement/walk")

func _on_stop_moving_timer_timeout() -> void:
	state = State.Idle
	$AnimationPlayer.play("idle/idle")
