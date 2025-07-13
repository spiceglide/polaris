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
	Hurt,
	Dead,
}

@export var jump_height = 13 * 32
@export var gravity = 20

var state = State.Idle
var last_dir = "east";
var last_wall_normal = 0
var jump_velocity = sqrt(2 * jump_height * gravity)
var jump_count = 0
var dash_count = 0
var running_time = 0
var checkpoint = Vector2.ZERO
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
	_move(delta)

func _move(delta: float) -> void:
	# Speed multiplier
	var mult = 0.5
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	# Reset velocities
	velocity.x = 0
	velocity.y += gravity
	
	match state:
		State.Idle:
			jump_count = 0
			dash_count = 0
			running_time = 0
			last_wall_normal = 0
			checkpoint = self.position
			
			# Determine direction
			if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				walk()
			
			# Ungrounded
			if not is_on_floor():
				state = State.Midair
			
			# Jumping
			if Input.is_action_just_pressed("move_up") or jump_buffered:
				jump()
			
			# Squat
			if Input.is_action_pressed("move_down"):
				squat()
			
		State.Walking:
			velocity.y = 0
			running_time += delta
			
			# Determine direction
			if Input.is_action_pressed("move_right"):
				if last_dir == "west":
					if running_time > 0.5:
						t = 20
						$AnimationPlayer.play("slide/descent")
					running_time = 0
				
				# Wall pushing
				if is_on_wall() and get_wall_normal().x < 0:
					push()
				
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
					if running_time > 0.5:
						t = 20
						$AnimationPlayer.play("slide/descent")
					running_time = 0
					
				# Wall pushing
				if is_on_wall() and get_wall_normal().x >= 0:
					push()
				
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
				jump()
			
			# Slide
			if Input.is_action_pressed("move_down"):
				slide()
			
		State.Pushing:
			velocity.y = 0
			running_time = 0
			
			var is_hugging_wall = (Input.is_action_pressed("move_left") and get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and get_wall_normal().x < 0)
			var is_opposing_wall = not is_hugging_wall and ((Input.is_action_pressed("move_left") and not get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and not get_wall_normal().x < 0))
			
			# Stop pushing
			if not is_hugging_wall:
				if is_opposing_wall:
					walk()
				else:
					idle()
					$AnimationPlayer.play("idle/idle")
				
			# Jumping
			if Input.is_action_just_pressed("move_up"):
				jump()
		State.Midair:
			running_time += delta
			
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
					jump()
					jump_count += 1
				else:  # Jump buffering
					jump_buffered = true
					$JumpBufferTimer.start()
			
			# Jump terminate
			if velocity.y <= 0 and Input.is_action_just_released("move_up"):  # jump terminate
				velocity.y = 0
			
			# Falling
			if velocity.y > 0:
				fall()
			
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
				land()
			
			# Dash
			if Input.is_action_pressed("interact") and dash_count < 2:
				dash_count += 1
				dash()
		State.Walled:
			velocity.y /= 1.3
			running_time = 0
			
			var is_hugging_wall = (Input.is_action_pressed("move_left") and get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and get_wall_normal().x < 0)
			var is_opposing_wall = (Input.is_action_pressed("move_left") and not get_wall_normal().x >= 0) or (Input.is_action_pressed("move_right") and not get_wall_normal().x < 0)
			
			# Wall jump
			if Input.is_action_pressed("move_up") and is_opposing_wall and (get_wall_normal().x != last_wall_normal):
				last_wall_normal = get_wall_normal().x
				wall_jump()
			
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
				$AnimationPlayer.play("wall/ground")
				idle()
		State.Squat:
			running_time = 0
			
			#Unsquat
			if not Input.is_action_pressed("move_down"):
				$AnimationPlayer.play("crouch/ascent")
				idle()
		State.Slide:
			running_time += delta
			
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
				squat()
		State.Dash:
			velocity.y = 0
			running_time = 0
			
			# Dash timer
			if $DashTimer.is_stopped():
				$DashTimer.start(0.4)
			
			# Set direction
			if last_dir == "west":
				velocity.x -= 1
			if last_dir == "east":
				velocity.x += 1
			
			# Friction
			t += 1
			velocity.x *= 11.0/t
			
			if is_on_wall():
				t = 0
				state = State.Walled
				$AnimationPlayer.play("wall/slide")
			if is_on_floor():
				t = 0
				squat()
		State.Hurt:
			velocity = Vector2.ZERO
			
			# Lose money
			if InventoryData.collectables.has("coins") and InventoryData.collectables["coins"] > 0:
				InventoryData.collectables["coins"] -= 1
			
			if $DamageTimer.is_stopped():
				PlayerData.health -= 20
				$AnimationPlayer.play("crouch/descent")
				$DamageTimer.start()
			
			if PlayerData.health <= 0:
				die()
		State.Dead:
			pass
	
	if velocity.length() > 0:
		velocity.x *= PlayerData.speed * mult
		move_and_slide()

func walk() -> void:
	state = State.Walking
	$AnimationPlayer.play("movement/walk")

func jump() -> void:
	state = State.Midair
	velocity.y = -jump_velocity * 3.5
	$AnimationPlayer.play("jump/ascent")

func idle() -> void:
	state = State.Idle
	$AnimationPlayer.queue("idle/idle")

func fall() -> void:
	state = State.Midair
	$AnimationPlayer.play("jump/descent")

func squat() -> void:
	state = State.Squat
	$AnimationPlayer.play("crouch/descent")

func unsquat() -> void:
	state = State.Idle
	$AnimationPlayer.play("crouch/ascent")
	$AnimationPlayer.queue("idle/idle")

func slide() -> void:
	state = State.Slide
	$AnimationPlayer.play("slide/descent")

func land() -> void:
	state = State.Idle
	$AnimationPlayer.play("jump/landing")
	$AnimationPlayer.queue("idle/idle")

func dash() -> void:
	state = State.Dash
	$AnimationPlayer.play("dash/overshoot")
	$AnimationPlayer.queue("dash/dash")

func wall_jump() -> void:
	state = State.Midair
	velocity.y = -jump_velocity * 2.5
	$AnimationPlayer.play("wall/prejump")
	$AnimationPlayer.queue("jump/ascent")

func push() -> void:
	state = State.Pushing
	$AnimationPlayer.play("movement/push")

func die() -> void:
	state = State.Dead
	$DamageTimer.stop()
	$Sprite.self_modulate = Color(0.3, 0.3, 0.3)

func _on_coyote_timer_timeout() -> void:
	state = State.Midair

func _on_wall_jump_timer_timeout() -> void:
	if is_on_floor():
		$AnimationPlayer.queue("movement/push")
		idle()
	else:
		fall()

func _on_jump_buffer_timer_timeout() -> void:
	jump_buffered = false

func _on_dash_timer_timeout() -> void:
	match state:
		State.Dash:
			t = 0
			fall()
		State.Slide:
			t = 0
			$AnimationPlayer.play("slide/ascent")
			walk()

func _on_stop_moving_timer_timeout() -> void:
	state = State.Idle
	$AnimationPlayer.play("idle/idle")

func _on_damage_timer_timeout() -> void:
	self.position = checkpoint
	state = State.Idle
	$AnimationPlayer.play("crouch/descent")
	$AnimationPlayer.queue("crouch/ascent")
	$AnimationPlayer.queue("idle/idle")

func _on_damage_hitbox_body_entered(body: Node2D) -> void:
	if state != State.Hurt:
		state = State.Hurt
