extends Area2D

export(float) var water_power := 0.75

onready var _jumping_player: State = $"../../../Player/StateMachine/Jump"

func _process(delta):
	for body in get_overlapping_bodies():
		if (body.name == "Player"): 
			_jumping_player.velocity.y += water_power * delta * 1000
