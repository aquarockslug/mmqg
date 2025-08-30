extends "common.gd"

onready var _timer_shoot: Timer = $"../../TimerShoot"
onready var _shoot_pos: Position2D = $"../../PositionShoot"
onready var has_shot: bool = false

func _ready() -> void:
	_timer_shoot.connect("timeout", self, "_on_shoot")

func _enter() -> void:
	if not owner.is_on_floor():
		emit_signal("finished", "idle")
	else:
		owner.face_player()
		animated_sprite.play("shoot")
		_timer_shoot.start()

func _update(delta: float) -> void:
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

func _on_shoot() -> void:
	if not has_shot:
		shoot()
		has_shot = true
		_timer_shoot.start()
	else:
		emit_signal("finished", "idle")

func shoot() -> void:
	var rubble := Rubble.instance()
	rubble.direction = owner.get_facing_direction()
	if not owner.is_restarting:
		owner.get_parent().add_child(rubble)
		rubble.global_position = owner.global_position + Vector2(
			_shoot_pos.position.x * owner.get_facing_direction().x,
			_shoot_pos.position.y
		)
