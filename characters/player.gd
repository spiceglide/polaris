extends CharacterBody2D

@export var speed = 400
@export var multiplier = 0.3
var last_dir = "south";

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$Sprite.set_state(last_dir, "idle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	PlayerData.position = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = multiplier

	# Determine direction
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		last_dir = "west"
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		last_dir = "east"
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		last_dir = "north"
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		last_dir = "south"
		velocity.y += 1

	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * mult
		$Sprite.set_state(last_dir, "walk")
		move_and_slide()
	else:
		$Sprite.set_state(last_dir, "idle")
