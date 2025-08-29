extends "common.gd"

onready var _timer_duration: Timer = $"../../TimerDigDuration"

func _ready() -> void:
	_timer_duration.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_player()
	animated_sprite.play("dig")
	_timer_duration.start()
	shoot()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)
	if randf() < 0.05: shoot()


func _on_timeout() -> void:
	emit_signal("finished", "idle")

