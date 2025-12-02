extends "common.gd"

onready var _timer_idle_delay: Timer = $"../../TimerIdleDelay"

var idle_fall_speed = 10

func _ready() -> void:
	_timer_idle_delay.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner._animation.play("idle")
	_timer_idle_delay.start()

func _update(delta: float) -> void:
	owner.move_and_slide(
		Vector2.DOWN * Constants.GRAVITY * idle_fall_speed,
		Constants.FLOOR_NORMAL
		)

func _on_timeout() -> void:
	_ray_cast.cast_to = owner.get_facing_direction() * _ray_cast_length
	_ray_cast.force_raycast_update()
	if _ray_cast.is_colliding(): # player is in short range
		emit_signal("finished", short_range_state())
	else:
		emit_signal("finished", long_range_state())

func short_range_state() -> String:
	return "bomb" if randf() < 0.25 else "dig"

func long_range_state() -> String:
	return "jump" if randf() < 0.25 else "shoot"
