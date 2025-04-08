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
	if health <= 0:
		state = State.Dead
	
	if is_night:
		warmth -= delta * 5
	
	if warmth <= 0:
		health = 0
