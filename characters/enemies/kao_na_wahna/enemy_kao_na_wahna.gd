extends "res://characters/enemies/base/enemy_base.gd"

# Similar to the Kao Na Gahna from mm8, but these totems spew water from the top instead to push the player

onready var _enemy_animations: AnimationPlayer = $"EnemyAnimations"

func _ready():
	while true:
		_enemy_animations.play("spray")
		yield(_enemy_animations, "animation_finished")
		_enemy_animations.play("idle")
		yield(_enemy_animations, "animation_finished")

func _process(delta):
	pass
