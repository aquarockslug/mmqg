extends State

onready var _animations: AnimationPlayer = $"../../BaseAnimations"
onready var _item_generator := $"../../ItemGenerator"

func _enter() -> void:
	owner.queue_free()
