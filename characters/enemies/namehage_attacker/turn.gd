extends State

func _enter() -> void:
	$"../../EnemyAnimations".play("turn_broken" if owner.is_broken else "turn")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "turn" || anim_name == "turn_broken" || anim_name == "break":
		$"../../Mask".position.x *= -1
		$"../../Mask".flip_h = not $"../../Mask".flip_h
		emit_signal("finished", "move")
