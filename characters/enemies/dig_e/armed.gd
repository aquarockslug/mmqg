extends State

var _velocity: Vector2

export(int) var init_drop_velocity := 250

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("armed")
	_velocity.y = init_drop_velocity

func _physics_process(delta: float) -> void:
	_velocity.y +=  Constants.GRAVITY * delta
	_velocity = owner.move_and_slide(_velocity)
