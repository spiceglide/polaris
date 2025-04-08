extends Node

enum State {
	Alive,
	Dead,
}

@export var speed: int = 400
@export var multiplier: float = 0.3
var position: Vector2 = Vector2.ZERO
var is_night: bool = false

var state = State.Alive
var health = 100
var hunger = 100
var warmth = 100
var sanity = 100

func _process(delta: float) -> void:
	# Dead men don't hunger
	if state == State.Dead:
		return
	
	# Death
	if health <= 0:
		state = State.Dead
	
	# The night is cold
	if is_night:
		warmth -= delta * 5
	
	# Hunger
	hunger -= delta * 0.5
	
	# Hungry and cold deaths
	if (hunger <= 0) or (warmth <= 0):
		health = 0
	
	# Clamp values at 0
	health = max(health, 0)
	hunger = max(hunger, 0)
	warmth = max(warmth, 0)
	sanity = max(sanity, 0)
