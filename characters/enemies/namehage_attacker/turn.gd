extends State

func _enter() -> void:
	if owner.is_broken:
		$"../../EnemyAnimations".play("turn_broken")
	else:
		$"../../EnemyAnimations".play("turn")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "turn" || anim_name == "turn_broken":
		$"../../Mask".position.x *= -1
		$"../../Mask".flip_h = not $"../../Mask".flip_h
		emit_signal("finished", "move")
