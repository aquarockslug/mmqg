extends "res://characters/enemies/base/enemy_base.gd"

export(int) var speed := 1000
export(int) var damage := 2
export(int) var gravity_scale := 3

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI
