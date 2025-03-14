extends CharacterBody2D
signal hit

@export var speed = 1500
@export var multiplier = 0.3
var last_dir = "down";


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = multiplier

	# Determine direction
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		last_dir = "left"
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		last_dir = "right"
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		last_dir = "up"
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		last_dir = "down"
		velocity.y += 1

	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * mult
		$AnimatedSprite2D.animation = last_dir
		move_and_slide()
	else:
		$AnimatedSprite2D.animation = last_dir + "_idle"
	
	$AnimatedSprite2D.play()
