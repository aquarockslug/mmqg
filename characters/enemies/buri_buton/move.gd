extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

var _velocity: Vector2

func _enter() -> void:
	_animations.play("move")
	owner.speed = owner.move_speed

func _process(delta: float) -> void:
	if owner.can_see_player(): emit_signal("finished", "rush")

func _physics_process(delta: float) -> void:
	_velocity = owner.get_facing_direction() * owner.speed * delta
	_velocity.y += Constants.GRAVITY * owner.gravity_scale
	_velocity = owner.move_and_slide(_velocity)

	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)

	# turn around if not moving horizontally
	if abs(_velocity.x) < 0.01:
		owner.toggle_flip_h()
		owner._ray.cast_to.x *= -1
