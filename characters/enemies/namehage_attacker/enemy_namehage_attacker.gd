tool
extends "res://characters/enemies/base/enemy_base.gd"

export(int) var speed := 125
export(int) var max_distance := 192
export(bool) var is_broken := false

var mask: Node = preload("res://characters/enemies/namehage_attacker/Mask.tscn").instance()

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
		
	if is_blocking && not is_broken: call_deferred("break_mask", body)
	else: ._on_hit(body)

func break_mask(weapon_projectile):
	is_broken = true	
	drop_mask()
	weapon_projectile.reflect()
	$EnemyAnimations.play("break")

# replace placeholder mask with the mask rigid body
func drop_mask():
	mask.global_position = $Mask.global_position
	Global.get_current_stage().add_child(mask)
	mask.set_direction($Mask.flip_h)
