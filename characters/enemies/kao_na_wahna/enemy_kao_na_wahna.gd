tool
extends "res://characters/enemies/base/enemy_base.gd"

# Similar to the Kao Na Gahna from mm8, but these totems spew water from the top instead to push the player
export(float) var water_power := 1.5
export(int, 2) var water_height := 2

onready var _enemy_animations: AnimationPlayer = $"EnemyAnimations"
onready var _water: AnimatedSprite = $"Water/TopSprite"

var entered: bool = false
var _jumping_player: State

func _ready():
	emit_signal("change_state", "idle")
	$"Water".connect("body_entered", self, "_on_water_body_entered")
	$"Water".connect("body_exited", self, "_on_water_body_exited")
	_enemy_animations.connect("animation_finished", self, "_after_animation")

func _process(delta):
	if not is_instance_valid(_enemy_animations): return
	if _enemy_animations.current_animation == "idle": return

	# hide all water with a y position that is below 0
	for water_part in _water.get_children():
		var water_part_y = _water.position.y + water_part.position.y
		water_part.visible = water_part_y < 0

	# push the player upwards while inside the water and jumping
	if entered && _jumping_player:
		_jumping_player.velocity.y += -water_power * delta * 1000

func _on_water_body_entered(body):
	if body and body.name == "Player":
		entered = true

		# force the player into the jump state when they enter the water
		body.emit_signal("change_state", "jump")

		# replace the normal initial jump velocity
		if not _jumping_player: _jumping_player = body.find_node("Jump")
		_jumping_player.velocity.y = -water_power * 50

func _on_water_body_exited(body):
	if body and body.name == "Player":
		entered = false

func _after_animation(anim_name):
	var water_animations = ["spray_short", "spray_middle", "spray_tall"]

	# if done being idle choose which spray animation to enter
	if anim_name == "idle":
		_enemy_animations.play(water_animations[water_height])

	# done spraying
	if water_animations.has(anim_name):
		emit_signal("change_state", "idle")

	if anim_name == "death": queue_free()
