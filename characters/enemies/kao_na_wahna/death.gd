extends State

onready var _enemy_animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _item_generator := $"../../ItemGenerator"
onready var _water = $"../../Water"

func _enter() -> void:
	_enemy_animations.play("death")
	
func _process(delta) -> void:
	if (_enemy_animations.current_animation == "death"):
		_water.position.y += 6
