extends "common.gd"

onready var _timer_duration: Timer = $"../../TimerDigSpeed"
onready var scatter_count: int = 0

func _ready() -> void:
	_timer_duration.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_center()
	owner._animation.play("dig")

	scatter_count = scatter_count + 1
	scatter_rubble()
	scatter_rubble()
	scatter_rubble()

	_timer_duration.start()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

func _on_timeout() -> void:
	scatter_count = scatter_count + 1
	if scatter_count >= 2:
		_timer_duration.stop()
		emit_signal("finished", "idle")
	else:
		owner._animation.play("dig")
		scatter_rubble()
		scatter_rubble()
		scatter_rubble()
