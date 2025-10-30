extends State

onready var _enemy_animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter():
	_enemy_animations.play("idle")
