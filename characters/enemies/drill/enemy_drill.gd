extends "res://characters/enemies/base/enemy_base.gd"

var touching_wall = false

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI

func _on_hit(body: PhysicsBody2D) -> void:
	if not body and not touching_wall:
		touching_wall = true
	._on_hit(body)
