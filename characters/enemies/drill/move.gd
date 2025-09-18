extends State

const VELOCITY: int = 1500

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("move")

func _update(delta: float) -> void:
	# change movement direction if the hitbox is touching a wall
	if owner.touching_wall:
		owner.set_flip_direction(!owner.flip_direction)
		owner.touching_wall = false
	owner.move_and_slide(owner.get_facing_direction() * VELOCITY * delta, Vector2.UP)


