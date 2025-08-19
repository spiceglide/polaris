extends CharacterBody2D

var last_dir = "south";
var is_holding = false
var interactable = []

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

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
	
	"""
	match PlayerData.state:
		PlayerData.State.Dead:
			$AnimationPlayer.play("action/death_1")
			$AnimationPlayer.queue("action/death_2")
		PlayerData.State.Sleeping:
			$AnimationPlayer.play("action/death_2")
		PlayerData.State.PullOut:
			$AnimationPlayer.play("action/pull")
		PlayerData.State.Holding:
			var item = InventoryData.get_selected_item()
			is_holding = item in InventoryData.holdable
			if not is_holding:
				PlayerData.state = PlayerData.State.Awake
			elif is_holding and item in ["torch"]:
				$Light.visible = true
		PlayerData.State.Kill1:
			$AnimationPlayer.play("action/kill_1")
		PlayerData.State.Cranking:
			$AnimationPlayer.play("action/crank")
	"""

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
