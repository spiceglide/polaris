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
var health: float = 100.0
var hunger: float = 100.0
var thirst: float = 100.0
var warmth: float = 100.0
var sanity: float = 0.0

var hunger_rate: float = 5 / 60.0
var thirst_rate: float = 10 / 60.0
var warmth_rate: float = 100 / 60.0

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
		hunger = 0
		thirst = 0
		warmth = 0
		
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
			warmth -= warmth_rate*delta * (1/heat)
		else:
			warmth += warmth_rate*delta * heat * 4
		
		# Hunger and thirst
		if hunger < 100:
			hunger -= hunger_rate*delta
		elif $HungerTimer.is_stopped():
			$HungerTimer.start()

		if thirst < 100:
			thirst -= thirst_rate*delta
		elif $ThirstTimer.is_stopped():
			$ThirstTimer.start()
		
		# Hungry and cold deaths
		if (hunger <= 0):
			health -= hunger_rate*delta
		if (thirst <= 0):
			health -= thirst_rate*delta
		if (warmth <= 0):
			health -= warmth_rate*delta
	
	# Clamp values at 0
	health = clamp(health, 0, 100)
	hunger = clamp(hunger, 0, 100)
	thirst = clamp(thirst, 0, 100)
	warmth = clamp(warmth, 0, 100)
	sanity = clamp(sanity, 0, 100)

func set_position(pos: Vector2):
	position = pos
	flags["position_updated"] = true


func _on_hunger_timer_timeout() -> void:
	if hunger >= 100:
		hunger = 99


func _on_thirst_timer_timeout() -> void:
	if thirst >= 100:
		thirst = 99
