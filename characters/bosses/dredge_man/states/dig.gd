extends "common.gd"

onready var _timer_duration: Timer = $"../../TimerDigDuration"
onready var _dig_pos: Position2D = $"../../PositionDig"

func _ready() -> void:
	_timer_duration.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_player()
	animated_sprite.play("dig")
	_timer_duration.start()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)
	if randf() < 0.025: scatter_rubble()

func _on_timeout() -> void:
	emit_signal("finished", "idle")

func scatter_rubble() -> void:
	var rubble := Rubble.instance()
	rubble.direction = owner.get_facing_direction()
	# _dig_pos.position.x = abs(_dig_pos.position.x) * owner.get_facing_direction().x
	if not owner.is_restarting:
		owner.get_parent().add_child(rubble)
		rubble.global_position = _dig_pos.global_position
