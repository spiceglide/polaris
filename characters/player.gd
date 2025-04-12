extends CharacterBody2D

var last_dir = "south";
var interactable = []

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$Sprite.set_direction(last_dir, "idle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	PlayerData.position = self.position
	
	match PlayerData.state:
		PlayerData.State.Dead:
			die()
		PlayerData.State.Sleeping:
			sleep()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if PlayerData.state == PlayerData.State.Awake:
		_move()

func _move() -> void:
	# Speed multiplier
	var mult = 1
	if Input.is_action_pressed("run"):
		mult = PlayerData.multiplier

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
		velocity = velocity.normalized() * PlayerData.speed * mult
		$Sprite.set_direction(last_dir, "walk")
		move_and_slide()
	else:
		$Sprite.set_direction(last_dir, "idle")

func die():
	$Sprite.set_state("death", false)
	$Shadow.visible = false

func sleep():
	$Sprite.set_state("sleep", false)
	$Shadow.visible = false
	
	if $SleepTimer.is_stopped():
		$SleepTimer.start(5)

func awaken():
	PlayerData.state = PlayerData.State.Awake
	$Sprite.set_direction(last_dir, "idle")
	$Shadow.visible = true

func _input(event):
	if event.is_action_pressed("interact"):
		if interactable:
			interactable[0].interact(self)

func _on_interaction_body_entered(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.append(interactive)

func _on_interaction_body_exited(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.erase(interactive)

func _on_sleep_timer_timeout() -> void:
	if WorldData.is_night():
		WorldData.new_day()
		awaken()
