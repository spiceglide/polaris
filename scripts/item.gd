extends Container
class_name Item

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var anim: String = "type1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite.animation = anim
	$Sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_to_group("items")
