extends Node

enum State {
	Awake,
	Dead,
	Sleeping,
	PullOut,
	Holding,
}

@export var speed: int = 400
@export var multiplier: float = 0.3
var position: Vector2 = Vector2.ZERO

var state = State.Awake
var health = 100
var hunger = 100
var warmth = 100
var sanity = 0

func _process(delta: float) -> void:
	# Dead men don't hunger
	if state == State.Dead:
		return
	
	# Death
	if health <= 0:
		state = State.Dead
		
	# The night is cold
	var heat = 1
	match WorldData.current_biome:
		"tundra":
			heat *= 0.1
		"forest":
			heat *= 0.15
		"swamp":
			heat *= 0.2
	if WorldData.is_night():
		warmth -= delta * (1/heat)
	else:
		warmth += delta * heat * 4
	
	# Hunger
	hunger -= delta * 0.5
	
	# Hungry and cold deaths
	if (hunger <= 0) or (warmth <= 0):
		health = 0
	
	# Clamp values at 0
	health = clamp(health, 0, 100)
	hunger = clamp(hunger, 0, 100)
	warmth = clamp(warmth, 0, 100)
	sanity = clamp(sanity, 0, 100)
