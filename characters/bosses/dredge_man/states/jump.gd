extends "common.gd"

export(int) var jump_speed := -20
export(int) var horizontal_speed := 50

var landing = false

func _enter() -> void:
	landing = false
	velocity.x = 0
	owner._animation.play("jump")

	yield(owner._animation, "animation_finished")

	velocity.y = jump_speed

	yield(get_tree().create_timer(0.25), "timeout")
	landing = true

func _update(delta: float) -> void:
	if owner._animation.current_animation != "jump":
		velocity.x = owner.get_facing_direction().x * horizontal_speed
		velocity.y = clamp(velocity.y + Constants.GRAVITY, -Constants.FALL_SPEED_MAX, Constants.FALL_SPEED_MAX)
		owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

	if owner.is_on_floor() and landing: _on_landing()

func _on_landing():
		# show crouch frame for a short time
		owner._sprite.frame = 10
		yield(get_tree().create_timer(0.1), "timeout")

		# update range finding ray cast
		_ray_cast.cast_to = owner.get_facing_direction() * _ray_cast_length
		_ray_cast.force_raycast_update()

		# if in range after jump drop bomb
		if _ray_cast.is_colliding():
			emit_signal("finished", "bomb")
		else: # maybe keep jumping if not in range
			if randf() < 0.5:
				emit_signal("finished", "jump")
			else:
				emit_signal("finished", "idle")


