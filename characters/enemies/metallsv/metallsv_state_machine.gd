extends StateMachine

func _ready() -> void:
	states_map["shoot"] = $Shoot
	states_map["hide"] = $Hide
	states_map["walk"] = $Walk
	states_map["death"] = $Death
