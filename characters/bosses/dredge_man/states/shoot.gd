extends "common.gd"

onready var _timer_shoot: Timer = $"../../TimerShoot"
onready var _shoot_pos: Position2D = $"../../PositionShoot"
onready var shot_count: int = 0

func _ready() -> void:
	_timer_shoot.connect("timeout", self, "_on_shoot")
	_timer_shoot.start()

func _enter() -> void:
	if not owner.is_on_floor():
		emit_signal("finished", "idle")
	else:
		owner.face_player()
		owner._animation.play("shoot")
		_timer_shoot.start()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

func _on_shoot() -> void:
	if shot_count >= 2:
		shot_count = 0
		emit_signal("finished", "idle")
	else:
		shot_count += 1
		shoot()
		_timer_shoot.start()

func shoot() -> void:
	var shovel := Shovel.instance()
	shovel.direction = owner.get_facing_direction()
	if not owner.is_restarting:
		owner.get_parent().add_child(shovel)
		shovel.global_position = owner.global_position + Vector2(
			_shoot_pos.position.x * owner.get_facing_direction().x,
			_shoot_pos.position.y
		)
