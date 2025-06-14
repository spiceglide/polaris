extends CharacterBody2D

var last_dir = "east";

@export var jump = 3.0
@export var gravity = 0.5
@export var max_airtime = 0.5

var airtime = 0

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
		
		# Airtime
		if is_on_floor():
			airtime = 0
		else:
			airtime += delta

func _move() -> void:
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier

	# Gravity
	velocity = Vector2.ZERO
	velocity.y = gravity
	
	# Determine direction
	if Input.is_action_pressed("move_left"):
		last_dir = "west"
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		last_dir = "east"
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		#last_dir = "north"
		velocity.y -= jump * (1 - (airtime / max_airtime))
	
	print(last_dir)
	
	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity * PlayerData.speed * mult
		move_and_slide()
	
	if velocity.x != 0:
		$Sprite.set_direction(last_dir, "walk", false)
	else:
		$Sprite.set_direction(last_dir, "idle", false)
