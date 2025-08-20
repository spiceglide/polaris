extends Node2D

@export var state: ObjState = ObjState.Unignited
@export var brightness: float = 1.0
@export var duration: float = 60*9
var time_used: float = 0

enum ObjState {
	Unignited,
	Ignited,
	Extinguished,
}

func _ready() -> void:
	var interact_node = self.find_child("Interaction")
	interact_node.connect("interaction", _on_interaction)

func _process(delta: float) -> void:
	match state:
		ObjState.Ignited:
			time_used += delta
			$Light.texture_scale = brightness * (1.0 - (time_used / duration) ** 4)
			
			if time_used > duration:
				state = ObjState.Extinguished
				$AnimatedSprite2D.animation = "extinguished"

func interact():
	match state:
		ObjState.Unignited:
			state = ObjState.Ignited
			$AnimatedSprite2D.animation = "ignited"
			$ActiveAudio.play()
			$Light.visible = true
		ObjState.Ignited:
			state = ObjState.Unignited
			$AnimatedSprite2D.animation = "unignited"
			$InactiveAudio.play()
			$Light.visible = false

func _on_interaction():
	interact()
