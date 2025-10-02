extends State

var _velocity: Vector2

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("move")

# func _update(delta: float) -> void:

func _physics_process(delta: float) -> void:
	_velocity = owner.get_facing_direction() * owner.speed * delta
	_velocity.y += Constants.GRAVITY * owner.gravity_scale
	_velocity = owner.move_and_slide(_velocity)

	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)
