extends StaticBody2D

@export var id: String
var states: Array
var current_state: State

var temp_material: Material

func _ready() -> void:
	states = $StateMachine.states.keys()
	temp_material = $Sprite2D.material

func _process(_delta: float) -> void:
	current_state = $StateMachine.current_state

func change_state(next: String):
	if next in states:
		$StateMachine.transition(current_state, next)

func highlight(enabled: bool):
	if enabled:
		$Sprite2D.material = load("res://shaders/highlight.tres")
	else:
		if temp_material:
			$Sprite2D.material = temp_material
		else:
			$Sprite2D.material = null
