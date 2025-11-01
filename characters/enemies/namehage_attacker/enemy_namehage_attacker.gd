tool
extends "res://characters/enemies/base/enemy_base.gd"

export(int) var speed := 125
export(int) var max_distance := 192
export(bool) var is_broken := false

func _ready() -> void:
	$Inputs.controller = InputHandler.Controller.AI
	$Inputs.ai = $AI

func _replace_with_spawner() -> void:
	spawn_info["max_distance"] = max_distance
	._replace_with_spawner()

func _on_hit(body: PhysicsBody2D) -> void:
	if body and body.is_in_group("PlayerWeapons"):
		if is_broken: 
			is_blocking = false
		else:
			is_blocking = get_facing_direction().x != body.direction.x
		
	if is_blocking && not is_broken: break_mask()
	else: ._on_hit(body)

func break_mask():
	is_broken = true
	$"EnemyAnimations".play("break")
