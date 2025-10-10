extends "common.gd"

onready var _animations: AnimationPlayer = $"../../AnimationBase"

func _enter() -> void:
	owner.set_facing_direction(Vector2.LEFT)
	$"../../CharacterSprites/AnimatedSprite".visible = false
	$"../../CharacterSprites/Sprite".visible = false
	get_tree().paused = true
	get_tree().set_group("BossDoors", "locked", true)
	_animations.play("drop_in")
	yield(_animations, "animation_finished")
	$"../../../DredgeRope".visible = true
	$"../../../DredgeBag".visible = true
	$"../../CharacterSprites/Sprite".visible = true
	owner.emit_signal("hit_points_changed", 0)
	owner.life_bar.visible = true
	owner.emit_signal("hit_points_changed", Constants.HIT_POINTS_MAX)
	yield(owner.life_bar, "gradual_update_complete")
	owner.is_invincible = false
	owner.is_restarting = false
	get_tree().paused = false
	owner.emit_signal("boss_ready")
	emit_signal("finished", "idle")
