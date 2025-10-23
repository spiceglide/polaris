extends CharacterBody2D

var last_dir = "south";
var interactable = []
var holding = null

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if PlayerData.flags["position_updated"]:
		self.position = PlayerData.position
		PlayerData.flags["position_updated"] = false
	
	PlayerData.position = self.position

	highlight_nearest()

func get_possible_interactions():
	var possible = ["crank", "gather", "operate"]
	if self.holding:
		var item = InventoryData.get_item_data(self.holding)
		var tags = item.get("tags", [])
		
		for tag in tags:
			if tag in ["chop", "dig"]:
				possible.append(tag)
		
	return possible

func highlight_nearest():
	var possible = get_possible_interactions()

	var first = true
	for object in interactable:
		if first:
			object.highlight(true, possible)
		else:
			object.highlight(false, possible)

		first = false

func place_structure(title: String) -> bool:
	print(title)
	return $StructurePlacer.place(title)

func change_state(next: String):
	if next in $StateMachine.states:
		$StateMachine.transition($StateMachine.current_state, next)

func _on_interaction_body_entered(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive:
		if interactive.is_in_group("interactive"):
			interactable.append(interactive)

func _on_interaction_body_exited(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive:
		if interactive.is_in_group("interactive"):
			interactive.highlight(false)
			interactable.erase(interactive)
