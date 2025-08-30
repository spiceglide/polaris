extends StaticBody2D

@export var id: String
@export var state_machine: StateMachine

var temp_material: Material

func _ready() -> void:
	if not state_machine:
		if self.get_node_or_null("StateMachine"):
			state_machine = $StateMachine

	if self.get_node_or_null("Sprite2D"):
		temp_material = $Sprite2D.material

func get_possible_states() -> Array[String]:
	return state_machine.states.keys()

func get_current_state() -> String:
	return state_machine.current_state.name.to_lower()

func change_state(next: String):
	if next in state_machine.states:
		state_machine.transition(state_machine.current_state, next)

func highlight(enabled: bool):
	if enabled:
		$Sprite2D.material = load("res://shaders/highlight.tres")
	else:
		if temp_material:
			$Sprite2D.material = temp_material
		else:
			$Sprite2D.material = null
