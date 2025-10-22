extends "res://characters/enemies/base/enemy_base.gd"

# Similar to the Kao Na Gahna from mm8, but these totems spew water from the top instead to push the player

export(int) var water_power := 1.5

onready var _enemy_animations: AnimationPlayer = $"EnemyAnimations"
onready var _water: AnimatedSprite = $"Water/TopSprite"

var entered = false

func _ready():
	while true:
		_enemy_animations.play("spray")
		yield(_enemy_animations, "animation_finished")
		_enemy_animations.play("idle")
		yield(_enemy_animations, "animation_finished")

func _process(delta):
	if _enemy_animations.current_animation == "idle": return 
	for water_part in _water.get_children():
		var water_part_y = _water.position.y + water_part.position.y
		water_part.visible = water_part_y < -5
		
	# push the player upwards while inside the water and jumping
	if entered: 
		$"../../../Player/StateMachine/Jump".velocity.y += -water_power * delta * 1000

func _on_water_body_entered(body):
	if body and body.name == "Player":
		# force the player into the jump state when they enter the water
		body.emit_signal("change_state", "jump")
		entered = true

func _on_water_body_exited(body):
	if body and body.name == "Player":
		entered = false
