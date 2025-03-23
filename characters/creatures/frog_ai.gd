extends CharacterBody2D

@export var speed = 3000
var state: State = State.Idle
var is_leaping: bool = false

enum State {
	Idle,
	Alert,
	Danger,
}

func _ready() -> void:
	$AnimatedSprite2D.animation = "ribbit"
	$AnimatedSprite2D.play()
	
func _process(delta: float) -> void:
	if state == State.Danger and not is_leaping:
		pass

func set_state(state: State):
	state = state
	
	match state:
		State.Idle:
				$AnimatedSprite2D.animation = "ribbit"
		State.Alert:
				$AnimatedSprite2D.animation = "idle"

func _on_alert_range_body_entered(body: Node2D) -> void:
	set_state(State.Alert)

func _on_alert_range_body_exited(body: Node2D) -> void:
	set_state(State.Idle)

func _on_danger_range_body_entered(body: Node2D) -> void:
	set_state(State.Danger)

func _on_danger_range_body_exited(body: Node2D) -> void:
	set_state(State.Alert)
