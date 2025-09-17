extends "res://characters/enemies/base/enemy_base.gd"

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI

func _on_hit(body: PhysicsBody2D) -> void:
	if not body:
		print("hit wall")
	._on_hit(body)
