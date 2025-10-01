extends "common.gd"

onready var _timer_duration: Timer = $"../../TimerDigSpeed"
onready var _dig_pos: Position2D = $"../../PositionDig"
onready var scatter_count: int = 0

func _ready() -> void:
	_timer_duration.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_player()
	owner._animation.play("dig")
	scatter_rubble()
	scatter_rubble()
	scatter_rubble()
	_timer_duration.start()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

func _on_timeout() -> void:
	scatter_count = scatter_count + 1
	if scatter_count >= 3:
		_timer_duration.stop()
		emit_signal("finished", "idle")
	else:
		owner._animation.play("dig")
		scatter_rubble()
		scatter_rubble()
		scatter_rubble()

func scatter_rubble() -> void:
	var rubble := Rubble.instance()
	rubble.direction = owner.get_facing_direction()
	if not owner.is_restarting:
		owner.get_parent().add_child(rubble)
		rubble.global_position = owner.global_position + Vector2(
			_dig_pos.position.x * owner.get_facing_direction().x,
			_dig_pos.position.y
		)
		rubble.fling()
