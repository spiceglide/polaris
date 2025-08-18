extends Node
class_name StateMachine

@export var parent_body: PhysicsBody2D
@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.parent_body = parent_body
			child.state_transitioned.connect(_on_child_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.update(delta)

func _physics_process(delta: float) -> void:
	if not current_state:
		return
	
	current_state.physics_update(delta)

func _on_child_transitioned(state, new_state_name):
	if (state != current_state) or (new_state_name not in states):
		return
	
	var new_state = states[new_state_name.to_lower()]
	
	if current_state:
		current_state.exit()
	new_state.enter()
	
	current_state = new_state
