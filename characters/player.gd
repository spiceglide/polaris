extends CharacterBody2D

var last_dir = "south";
var is_holding = false
var interactable = []

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$Sprite.set_direction(last_dir, "idle", is_holding)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if PlayerData.flags["position_updated"]:
		self.position = PlayerData.position
		PlayerData.flags["position_updated"] = false
	
	PlayerData.position = self.position
	is_holding = false
	$Light.visible = false
	
	match PlayerData.state:
		PlayerData.State.Dead:
			$Sprite.set_direction(last_dir, "death", is_holding)
			$Shadow.visible = false
		PlayerData.State.Sleeping:
			$Sprite.set_direction(last_dir, "sleep", is_holding)
			$Shadow.visible = false
		PlayerData.State.PullOut:
			$Sprite.set_direction(last_dir, "pull", is_holding)
		PlayerData.State.Holding:
			var item = InventoryData.get_selected_item()
			is_holding = item in InventoryData.holdable
			if not is_holding:
				PlayerData.state = PlayerData.State.Awake
			elif is_holding and item in ["torch"]:
				$Light.visible = true
		PlayerData.State.Kill1:
			$Sprite.set_direction(last_dir, "kill_1", is_holding)
			$Shadow.visible = false
		PlayerData.State.Cranking:
			$Sprite.set_direction(last_dir, "crank", is_holding)

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
		$Sprite.set_direction(last_dir, "walk", is_holding)
		move_and_slide()
	else:
		$Sprite.set_direction(last_dir, "idle", is_holding)

func _input(event):
	if event.is_action_pressed("interact"):
		if interactable:
			interactable[0].interact(self)

func _on_interaction_body_entered(body: Node2D) -> void:
	print(body)
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.append(interactive)

func _on_interaction_body_exited(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.erase(interactive)

func _on_sleep_timer_timeout() -> void:
	if WorldData.is_night():
		SceneSwitcher.load_dream_game()
		#WorldData.new_day()
		#PlayerData.state = PlayerData.State.Awake

func _on_animation_finished() -> void:
	match PlayerData.state:
		PlayerData.State.PullOut:
			PlayerData.state = PlayerData.State.Holding
			is_holding = true
			last_dir = "south"
		PlayerData.State.Sleeping:
			$Sprite.pause()
			if $SleepTimer.is_stopped():
				$SleepTimer.start(5)
		PlayerData.State.Dead:
			$Sprite.pause()
		PlayerData.State.Kill1:
			PlayerData.state = PlayerData.State.Kill2
			$Sprite.set_direction(last_dir, "kill_2", is_holding)
			$Shadow.visible = false
		PlayerData.State.Kill3:
			var item = InventoryData.get_selected_item()
			InventoryData.remove_items([item])
			InventoryData.set_item_at_selected("%s_dead" % item)
			PlayerData.sanity += 40
			PlayerData.state = PlayerData.State.Awake
		PlayerData.State.Cranking:
			PlayerData.state = PlayerData.State.Awake

func _on_animation_looped() -> void:
	match PlayerData.state:
		PlayerData.State.Kill3:
			if $Sprite/Body.animation != "kill_3":
				$Sprite.set_direction(last_dir, "kill_3", is_holding)
				$Shadow.visible = false
