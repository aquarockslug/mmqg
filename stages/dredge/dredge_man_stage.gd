extends Stage

onready var _music: Node
onready var _boss: Node2D
onready var _boss_door: Node2D
onready var _material = $"Background/bg1".get_material()

func _process(delta):
	_material.set_shader_param("scroll", _material.get_shader_param("scroll") + 0.001)

func _notification(what):
	# Temporary workaround until the following engine issue will be fixed.
	# https://github.com/godotengine/godot/issues/33620
	# Order of onready variables in sub-classes is broken.
	match what:
		NOTIFICATION_INSTANCED:
			_music = $Music
			_boss_door = $"BossDoors/BossDoor01"
			_boss = $"Sections/BossRoom/DredgeMan"

func _connect_signals() -> void:
	._connect_signals()

	# Music
	_try_connect(self, "restarted", _music, "on_restarted")
	_try_connect(_gui_pause, "game_paused", _music, "on_game_paused")
	_try_connect(_gui_pause, "game_resumed", _music, "on_game_resumed")
	_try_connect(player, "died", _music, "on_died")

	# Stage Boss
	_try_connect(self, "restarted", _boss, "reset")
	_try_connect(_boss, "boss_ready", _music, "on_boss_ready")
	_try_connect(_boss, "boss_died", _music, "on_boss_died")
	_try_connect(_boss, "boss_died", self, "_on_boss_died")
	_try_connect(_boss, "boss_died", player, "on_boss_died")

	# Stage Boss Doors
	_try_connect(_boss_door, "closed", _boss, "on_boss_entered")
	_try_connect(_boss_door, "closed", player, "on_boss_entered")
	_try_connect(_boss_door, "closed", _music, "on_boss_entered")

	for boss_door in get_tree().get_nodes_in_group("BossDoors"):
		_try_connect(self, "restarted", boss_door, "on_restarted")
		for checkpoint in get_tree().get_nodes_in_group("Checkpoints"):
			_try_connect(checkpoint, "checkpoint_reached", boss_door, "on_checkpoint_reached")
