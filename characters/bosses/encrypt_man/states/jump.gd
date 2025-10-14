extends "common.gd"

export(int) var jump_power := -300
export(int) var horizontal_speed := 50

func _enter() -> void:
	owner._animation.play("jump")
	# randomize the jump power
	velocity.y = jump_power * (1 + randf())

func _update(delta: float) -> void:
	velocity.x = owner.get_facing_direction().x * horizontal_speed
	velocity.y = clamp(velocity.y + Constants.GRAVITY, -Constants.FALL_SPEED_MAX, Constants.FALL_SPEED_MAX)
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

	if owner.is_on_floor(): _on_landing()

func _on_landing():
		if randf() < 0.5:
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "idle")


