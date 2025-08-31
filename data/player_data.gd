extends Node

enum State {
	Awake,
	Dead,
	Sleeping,
	PullOut,
	Holding,
	Cranking,
	Kill1,
	Kill2,
	Kill3,
}

@export var speed: int = 400
@export var multiplier: float = 1.3
var position: Vector2 = Vector2.ZERO

var state = State.Awake
var health = 100.0
var hunger = 100.0
var thirst = 100.0
var warmth = 100.0
var sanity = 0.0

var flags = {
	"position_updated": false,
}

func _process(delta: float) -> void:
	# Dead men don't hunger
	if state == State.Dead:
		return
	
	# Death
	if health <= 0:
		state = State.Dead
		
	# The night is cold
	if WorldData.get_game_mode() == "overworld":
		var heat = 1
		match WorldData.current_biome:
			"tundra":
				heat *= 0.2
			"forest":
				heat *= 0.3
			"swamp":
				heat *= 0.4
		if WorldData.is_night():
			warmth -= delta * (1/heat)
		else:
			warmth += delta * heat * 4
		
		# Hunger
		hunger -= delta * 0.5
		
		# Hungry and cold deaths
		if (hunger <= 0):
			health -= delta
		if (warmth <= 0):
			health -= delta
	
	# Clamp values at 0
	health = clamp(health, 0, 100)
	hunger = clamp(hunger, 0, 100)
	thirst = clamp(thirst, 0, 100)
	warmth = clamp(warmth, 0, 100)
	sanity = clamp(sanity, 0, 100)

func set_position(pos: Vector2):
	position = pos
	flags["position_updated"] = true
