extends CharacterBody2D

var last_dir = "south";
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

	highlight_nearest()

func get_possible_interactions():
	var item = InventoryData.get_selected_item_data()
	var possible = ["crank", "gather", "operate"]

	if "chop" in item.get("tags", []):
		possible.append("chop")
	
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
	return $StructurePlacer.place(title)

func change_state(next: String):
	if next in $StateMachine.states:
		$StateMachine.transition($StateMachine.current_state, next)

func _on_interaction_body_entered(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive:
		PlayerData.vicinity.append(interactive.parent.id)
		
		if interactive.is_in_group("interactive"):
			interactable.append(interactive)

func _on_interaction_body_exited(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive:
		PlayerData.vicinity.erase(interactive.parent.id)
		
		if interactive.is_in_group("interactive"):
			interactive.highlight(false)
			interactable.erase(interactive)
