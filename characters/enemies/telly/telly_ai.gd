extends AI

func _get_input_direction() -> Vector2:
	if Global.player:
		var target = Vector2(Global.player.global_position.x, owner.global_position.y)
		owner.flip_direction = target.x > owner.global_position.x
		return owner.global_position.direction_to(target)
	else:
		return Vector2.ZERO
