extends Stage

onready var _boss: Node2D
onready var _boss_door: Node2D

func _notification(what):
	match what:
		NOTIFICATION_INSTANCED:
			_boss_door = $"BossDoors/BossDoor01"
			_boss = $"Sections/Section06/RagWomen"

func _connect_signals() -> void:
	._connect_signals()

	# Stage Boss Doors
	_try_connect(_boss_door, "closed", _boss, "on_boss_entered")
	_try_connect(_boss_door, "closed", player, "on_boss_entered")

	for boss_door in get_tree().get_nodes_in_group("BossDoors"):
		_try_connect(self, "restarted", boss_door, "on_restarted")
		for checkpoint in get_tree().get_nodes_in_group("Checkpoints"):
			_try_connect(checkpoint, "checkpoint_reached", boss_door, "on_checkpoint_reached")
