tool
extends "res://characters/enemies/base/enemy_base.gd"

onready var _backside: Area2D = $"../../Backside"

export(int) var max_distance := 192
export(bool) var broken := false

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI

func _replace_with_spawner() -> void:
	spawn_info["max_distance"] = max_distance
	._replace_with_spawner()

func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		is_blocking = get_facing_direction().x != body.direction.x
	._on_hit(body)
