extends State

const VELOCITY: int = 24

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

var hide_position

func _ready():
	hide_position = owner.position

func _enter():
	_animations.play("flap")

func _update(delta: float) -> void:
	if _animations.current_animation == "flap":
		owner.move_and_slide(move_direction() * VELOCITY, Vector2.UP)

	if owner.global_position.distance_to(hide_position) < 1:
		emit_signal("finished", "hide")

func move_direction():
	var target = hide_position
	owner.flip_direction = target.x > owner.global_position.x
	return owner.global_position.direction_to(target)
