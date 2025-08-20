extends Node2D

@export var state: ObjState = ObjState.Raised
var times_used: int = 0

enum ObjState {
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
		state = ObjState.Disrepair
		$Sprite/Base.animation = "disrepair"
		$Sprite/Top.animation = "disrepair"
		return
	
	match state:
		ObjState.Raised:
			state = ObjState.Lowering
			$Sprite/Top.animation = "lowering"
			$Sprite/Top.play()
			
			PlayerData.state = PlayerData.State.Cranking
			PlayerData.set_position($Handle/CollisionShape2D.global_position)
		ObjState.Lowered:
			state = ObjState.Raising
			$Sprite/Top.animation = "raising"
			$Sprite/Top.play()
			
			PlayerData.state = PlayerData.State.Cranking
			PlayerData.set_position($Handle/CollisionShape2D.global_position)

func _on_interaction():
	interact()

func _on_animation_finished() -> void:
	$Sprite/Base.animation = "default"
	
	match state:
		ObjState.Lowering:
			self.state = ObjState.Lowered
			$Sprite/Top.animation = "lowered"
			PlayerData.state = PlayerData.State.Awake
		ObjState.Raising:
			self.state = ObjState.Raised
			$Sprite/Top.animation = "raised"
			PlayerData.state = PlayerData.State.Awake
