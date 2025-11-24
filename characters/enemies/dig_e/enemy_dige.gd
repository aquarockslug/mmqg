extends "res://characters/enemies/base/enemy_base.gd"

onready var _timer_fuse: Timer = $TimerBombFuse

export(int) var damage := 2

var exploded = false

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI

	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()

func _on_explode():
	_timer_fuse.stop()
	exploded = true
	set_physics_process(false) # stop the physics process loop
	emit_signal("change_state", "death")
