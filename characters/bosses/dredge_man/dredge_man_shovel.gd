extends KinematicBody2D

export(float) var speed := 1.25
export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT

onready var _area := $Area2D

func _ready() -> void:
	$Sprite.flip_h = direction == Vector2.LEFT
	_velocity = Vector2(speed * direction.x, 0)

func _physics_process(delta: float) -> void:
	var _collision = move_and_collide(_velocity)
	if _collision: queue_free()
	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)
