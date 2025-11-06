extends "res://characters/enemies/base/enemy_base.gd"

export(int) var explosion_scale := 4

onready var _timer_fuse: Timer = $TimerBombFuse

export(int) var damage := 2

var exploded = false

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI

	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()

func _on_explode():
	_timer_fuse.stop()
	exploded = true
	_player_collision_area.scale = Vector2(explosion_scale, explosion_scale)
	set_physics_process(false) # stop the physics process loop
	emit_signal("change_state", "death")
