extends "common.gd"

onready var _timer_idle_delay: Timer = $"../../TimerIdleDelay"

func _ready() -> void:
	_timer_idle_delay.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_player()
	owner._animation.play("idle")
	_timer_idle_delay.start()

func _update(delta: float) -> void:
	owner.move_and_slide(Vector2.DOWN * Constants.GRAVITY, Constants.FLOOR_NORMAL)

func _on_timeout() -> void:
	emit_signal("finished", "jump")
