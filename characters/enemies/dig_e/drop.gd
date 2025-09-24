extends State

var _velocity: Vector2

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("drop")
	_velocity.y = 250

func _physics_process(delta: float) -> void:
	_velocity.y +=  Constants.GRAVITY * delta
	_velocity = owner.move_and_slide(_velocity)

