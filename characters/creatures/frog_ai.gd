extends CharacterBody2D

enum EnemyState {
	Idle,
	Alert,
	Flee,
}

@export var speed = 1000
@export var leap_duration = 12
@export var leap_count = 2
var state: EnemyState = EnemyState.Idle
var leap_time = 0
var speech_time = 0
var leap_direction = Vector2.ZERO
var last_player_pos = Vector2.ZERO

func _ready() -> void:
	$AnimatedSprite2D.animation = "ribbit"
	
func _process(delta: float) -> void:
	if leap_time > (leap_duration * leap_count):
		finish_leap()
		
	if state == EnemyState.Flee:
		if leap_time == 0:
			start_leap()
	
	if leap_time > 0:
		leap_time += 1
	
	if leap_time == 0:
		match state:
			EnemyState.Idle:
				$AnimatedSprite2D.animation = "ribbit"
				$Announcement.idle_chatter = [tr("ENEMY_FROG_IDLE_1")]
			EnemyState.Alert:
				$AnimatedSprite2D.animation = "idle"
				$Announcement.idle_chatter = [tr("ENEMY_FROG_ALERT_1"), tr("ENEMY_FROG_ALERT_2")]

func _physics_process(delta: float) -> void:
	# Determine direction
	velocity = leap_direction

	# Normalise velocity
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide()

func start_leap():
	var threat_direction = self.position.direction_to(last_player_pos)
	leap_time = 1
	
	if threat_direction.x < 0:
		leap_direction.x = 1
		$AnimatedSprite2D.flip_h = false
	else:
		leap_direction.x = -1
		$AnimatedSprite2D.flip_h = true

	var up_down = randf()
	if up_down < 0.33:
		leap_direction.y = 1
	elif up_down < 0.66:
		leap_direction.y = 0
	else:
		leap_direction.y = -1
		
	$AnimatedSprite2D.animation = "leap"
	

func finish_leap():
	leap_direction = Vector2.ZERO
	leap_time = 0

func _on_alert_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		self.state = EnemyState.Alert
		last_player_pos = body.position

func _on_alert_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		self.state = EnemyState.Idle
		last_player_pos = body.position

func _on_danger_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		self.state = EnemyState.Flee
		last_player_pos = body.position
		$Announcement.announce(tr("ENEMY_FROG_FLEE_1"))

func _on_danger_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		self.state = EnemyState.Alert
		last_player_pos = body.position
