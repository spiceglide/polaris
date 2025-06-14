extends CharacterBody2D

var last_dir = "east";

var jump = 150.0
var gravity = 0.5

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
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier

	# Determine direction
	velocity = Vector2.ZERO
	velocity.y = gravity
	if Input.is_action_pressed("move_left"):
		last_dir = "west"
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		last_dir = "east"
		velocity.x += 1
	if Input.is_action_pressed("move_up") and is_on_floor():
		#last_dir = "north"
		velocity.y -= 1
	if Input.is_action_pressed("move_down") and not is_on_floor():
		#last_dir = "south"
		velocity.y += 1
	
	print(last_dir)
	$Sprite.set_direction(last_dir, "idle", false)
	
	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity * PlayerData.speed * mult
		move_and_slide()
