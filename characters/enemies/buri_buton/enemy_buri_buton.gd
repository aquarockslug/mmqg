extends "res://characters/enemies/base/enemy_base.gd"

onready var _ray: RayCast2D = $"Collider/LineOfSite"

export(int) var move_speed := 600
export(int) var damage := 2
export(int) var gravity_scale := 3

var speed := 1000

func can_see_player() -> bool:
	return _ray.is_colliding()
