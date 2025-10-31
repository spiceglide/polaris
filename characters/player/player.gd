extends CharacterBody2D

var last_dir: String = "south";
var interactable: Array[StaticBody2D] = []
var holding: GameItem = null
var placing: GameItem = null

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
		var tags: Array[String]
		tags.assign(self.holding.get("tags"))
		
		for tag in tags:
			if tag in ["chop", "dig"]:
				possible.append(tag)
		
	return possible

func highlight_nearest():
	print("TEST")
	var possible = get_possible_interactions()
	print(possible)
	print()

	var first = true
	for object in interactable:
		if first:
			object.highlight(true, possible)
		else:
			object.highlight(false, possible)

		first = false

func place_structure(title: GameItem):
	placing = title
	$StructurePlacer.place(title)

func complete_structure():
	placing = null
	$StructurePlacer.complete()

func cancel_structure():
	placing = null
	$StructurePlacer.cancel()

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
