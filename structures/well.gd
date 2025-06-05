extends Node2D

@export var state: State = State.Raised
var times_used: int = 0

enum State {
	Raised,
	Lowered,
	Raising,
	Lowering,
	Disrepair,
}

func _ready() -> void:
	var interact_node = self.find_child("Interaction")
	interact_node.connect("interaction", _on_interaction)

func interact():
	times_used += 1
	
	if times_used > 30:
		state = State.Disrepair
		$Sprite/Base.animation = "disrepair"
		$Sprite/Top.animation = "disrepair"
		return
	
	match state:
		State.Raised:
			state = State.Lowering
			$Sprite/Top.animation = "lowering"
			$Sprite/Top.play()
			
			PlayerData.state = PlayerData.State.Cranking
			PlayerData.set_position($Handle/CollisionShape2D.global_position)
		State.Lowered:
			state = State.Raising
			$Sprite/Top.animation = "raising"
			$Sprite/Top.play()
			
			PlayerData.state = PlayerData.State.Cranking
			PlayerData.set_position($Handle/CollisionShape2D.global_position)

func _on_interaction():
	interact()

func _on_animation_finished() -> void:
	$Sprite/Base.animation = "default"
	
	match state:
		State.Lowering:
			self.state = State.Lowered
			$Sprite/Top.animation = "lowered"
			PlayerData.state = PlayerData.State.Awake
		State.Raising:
			self.state = State.Raised
			$Sprite/Top.animation = "raised"
			PlayerData.state = PlayerData.State.Awake
