extends State

var distance_traveled: float

onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	$"../../EnemyAnimations".play("move_broken" if owner.is_broken else "move")
	distance_traveled = 0

func _update(delta: float) -> void:
	distance_traveled += owner.speed * delta
	owner.move_and_slide(_inputs.get_input_direction() * owner.speed)

	if _inputs.get_input_direction() == -owner.get_facing_direction():
		emit_signal("finished", "turn")
