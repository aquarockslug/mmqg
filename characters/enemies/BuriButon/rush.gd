extends State

var _velocity: Vector2

func _enter() -> void:
	$"../../EnemyAnimations".play("rush")
	owner.speed = owner.move_speed * 2

func _process(delta: float) -> void:
	if not owner.can_see_player():
		emit_signal("finished", "move")

func _physics_process(delta: float) -> void:
	_velocity = owner.get_facing_direction() * owner.speed * delta
	_velocity.y += Constants.GRAVITY * owner.gravity_scale
	_velocity = owner.move_and_slide(_velocity)

	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)
