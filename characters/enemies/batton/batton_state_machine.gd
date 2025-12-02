extends "res://characters/enemies/base/scripts/enemy_state_machine.gd"

func _ready() -> void:
    states_map["hide"] = $Hide
    states_map["move"] = $Move
    states_map["retreat"] = $Retreat
