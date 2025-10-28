extends State

onready var _enemy_animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter():
	_enemy_animations.play("idle")

func _on_enemyAnimations_animation_finished(anim_name):
	if (anim_name == "idle"):
		emit_signal("finished", "spray")
