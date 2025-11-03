extends "res://characters/enemies/base/scripts/enemy_state_machine.gd"

func _ready() -> void:
    states_map["triple"] = $Triple
    states_map["double"] = $Double
    states_map["single"] = $Single
