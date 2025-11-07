extends State

@export var states: Array[String] = ["empty", "full1", "full2", "full3"]
var own_name: String

func _ready() -> void:
	own_name = self.name.to_lower()

func enter():
	var anim := parent.get_node_or_null("AnimationPlayer")
	anim.play(own_name)

func update(_delta: float) -> void:
	var slot_count := 0.0
	var occupied_slot_count := 0.0
	
	if (not parent.inventory) or len(parent.inventory.slots) <= 0:
		return
	
	for slot in parent.inventory.slots:
		slot_count += 1
		if not slot.is_empty():
			occupied_slot_count += 1
	
	var idx: int = ceil(len(states) * (occupied_slot_count / slot_count))
	idx = min(idx, len(states) - 1)
	var next_state := states[idx]
	if next_state != own_name:
		state_transitioned.emit(self, next_state)
