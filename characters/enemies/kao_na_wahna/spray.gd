extends State

onready var _enemy_animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter():
	# choose which spray animation to enter 
	if (owner.water_height == 0):
		_enemy_animations.play("spray_short")
	if (owner.water_height == 1):
		_enemy_animations.play("spray_middle")
	if (owner.water_height == 2):
		_enemy_animations.play("spray_tall")
