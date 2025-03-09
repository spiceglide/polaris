extends Area2D
signal hit

@export var speed = 400
var multiplier


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Speed multiplier
	if Input.is_action_pressed("run"):
		multiplier = 1.5
	else:
		multiplier = 1

	# Determine direction
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * (speed * multiplier)
		#$AnimatedSprite2D.play()
	else:
		pass
		#$AnimatedSprite2D.play()
	
	# Set position
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

	# Animations
	if velocity.y < 0:
		pass
		#$AnimatedSprite2D.animation = "up"
	elif velocity.y > 0:
		pass
		#$AnimatedSprite2D.animation = "down"
	elif velocity.x < 0:
		pass
		#$AnimatedSprite2D.animation = "left"
	elif velocity.x > 0:
		pass
		#$AnimatedSprite2D.animation = "right"


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
