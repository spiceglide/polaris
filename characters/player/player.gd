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

func place_structure(name: String) -> bool:
	var scene = WorldData.current_scene
	var tilemap = scene.get_node("TileMap")
	
	var instance = load('res://structures/%s.tscn' % name).instantiate()
	scene.add_child(instance)
	instance.global_position = PlayerData.position
	instance.global_position.x += 150
	return true

func _on_interaction_body_entered(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.append(interactive)

func _on_interaction_body_exited(body: Node2D) -> void:
	var interactive = body.get_node("Interaction")
	if interactive and interactive.is_in_group("interactive"):
		interactable.erase(interactive)
