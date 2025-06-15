extends CharacterBody2D

enum State {
	Grounded,
	Midair,
	Walled,
}

@export var jump_height = 1800
@export var gravity = 50

var state = State.Grounded
var last_dir = "east";
var jump_velocity = sqrt(2 * jump_height * gravity)
var jump_count = 0

func _process(delta: float) -> void:
	if PlayerData.flags["position_updated"]:
		self.position = PlayerData.position
		PlayerData.flags["position_updated"] = false
	
	PlayerData.position = self.position
	$Light.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if PlayerData.state in [PlayerData.State.Awake, PlayerData.State.Holding]:
		_move()

func _move() -> void:
	# Speed multiplier
	var mult = 2
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier
	
	if is_on_floor():
		state = State.Grounded
	elif is_on_wall_only() and velocity.y > 0:
		if Input.is_action_pressed("move_left") and get_wall_normal().x == 1:
			state = State.Walled
		elif Input.is_action_pressed("move_right") and get_wall_normal().x == -1:
			state = State.Walled
	else:
		state = State.Midair
	
	velocity.x = 0
	velocity.y += gravity
	
	match state:
		State.Grounded:
			# Determine direction
			if Input.is_action_pressed("move_left"):
				last_dir = "west"
				velocity.x -= 1
			if Input.is_action_pressed("move_right"):
				last_dir = "east"
				velocity.x += 1
			
			# Jumping
			if Input.is_action_pressed("move_up"):
				velocity.y = -jump_velocity * 3.5
				jump_count = 1
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
			
			# Jump terminate
			if Input.is_action_just_released("move_up") and jump_count <= 2:  # jump terminate
				velocity.y = 0

		State.Walled:
			velocity.y /= 1.5
			
			if Input.is_action_just_pressed("move_up"):
				print(get_wall_normal())
			match get_wall_normal().x:
				1.0:
					velocity.x = 10
					velocity.y = -jump_velocity * 2
				-1.0:
					velocity.x = -10
					velocity.y = -jump_velocity * 2
	
	
	if velocity.length() > 0:
		velocity.x *= PlayerData.speed * mult
		move_and_slide()

	
	if velocity.x != 0:
		$Sprite.set_direction(last_dir, "walk", false)
	else:
		$Sprite.set_direction(last_dir, "idle", false)
