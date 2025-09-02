extends "common.gd"

export(int) var jump_speed := -50
export(int) var horizontal_speed := 50

func _enter() -> void:
	animated_sprite.play("jump")
	velocity.y = jump_speed

func _update(delta: float) -> void:
	velocity.x = owner.get_facing_direction().x * horizontal_speed
	velocity.y = clamp(velocity.y + Constants.GRAVITY, -Constants.FALL_SPEED_MAX, Constants.FALL_SPEED_MAX)
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

	if owner.is_on_floor(): _on_landing()

func _on_landing():
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


