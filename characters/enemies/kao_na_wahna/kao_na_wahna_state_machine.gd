extends "res://characters/enemies/base/scripts/enemy_state_machine.gd"

func _ready() -> void:
	states_map["idle"] = $Idle
	states_map["spray"] = $Spray
