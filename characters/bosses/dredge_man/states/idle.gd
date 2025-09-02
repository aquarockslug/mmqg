extends "common.gd"

onready var _timer_idle_delay: Timer = $"../../TimerIdleDelay"

func _ready() -> void:
	_timer_idle_delay.connect("timeout", self, "_on_timeout")

func _enter() -> void:
	owner.face_player()
	animated_sprite.play("idle")
	_timer_idle_delay.start()

func _update(delta: float) -> void:
	owner.move_and_slide(Vector2.DOWN * Constants.GRAVITY, Constants.FLOOR_NORMAL)

func _on_timeout() -> void:
	_ray_cast.cast_to = owner.get_facing_direction() * _ray_cast_length
	_ray_cast.force_raycast_update()
	if _ray_cast.is_colliding(): # player is in short range
		emit_signal("finished", short_range_state())
	else:
		emit_signal("finished", long_range_state())

	# trigger mines?
	#if timer_cooldown.is_stopped() and owner.is_on_floor():
	#	timer_cooldown.start(COOLDOWN + randf() * 0.6)

func short_range_state() -> String:
	return "bomb" if randf() < 0.33 else "dig"

func long_range_state() -> String:
	return "jump" if randf() < 0.33 else "shoot"
