extends State

const VELOCITY: int = 0

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

var direction = Vector2.LEFT

func _enter() -> void:
	_animations.play("move")

func _update(delta: float) -> void:
	owner.move_and_slide(direction * VELOCITY * delta, Vector2.UP)
