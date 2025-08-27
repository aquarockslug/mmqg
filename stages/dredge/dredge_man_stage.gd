extends Stage

onready var _music: Node
onready var _boss: Node2D
onready var _boss_door: Node2D

func _notification(what):
	# Temporary workaround until the following engine issue will be fixed.
	# https://github.com/godotengine/godot/issues/33620
	# Order of onready variables in sub-classes is broken.
	match what:
		NOTIFICATION_INSTANCED:
			_boss_door = $"BossDoors/BossDoor01"
			_boss = $"Sections/Section07/DredgeMan"

func _connect_signals() -> void:
	._connect_signals()

	# Stage Boss
	_try_connect(self, "restarted", _boss, "reset")
	_try_connect(_boss, "boss_died", self, "_on_boss_died")
	_try_connect(_boss, "boss_died", player, "on_boss_died")

	# Stage Boss Doors
	_try_connect(_boss_door, "closed", _boss, "on_boss_entered")
	_try_connect(_boss_door, "closed", player, "on_boss_entered")
