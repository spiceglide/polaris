extends StaticBody2D

@export var id: String
var states: Array
var current_state: State

func _ready() -> void:
	states = $StateMachine.states.keys()

func _process(_delta: float) -> void:
	current_state = $StateMachine.current_state

func change_state(next: String):
	if next in states:
		$StateMachine.transition(current_state, next)

func highlight(enabled: bool):
	if enabled:
		$Sprite2D.material = load("res://shaders/highlight.tres")
	else:
		$Sprite2D.material = null
