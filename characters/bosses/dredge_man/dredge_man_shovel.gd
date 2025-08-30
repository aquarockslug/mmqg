extends KinematicBody2D

export(int) var speed := 300
export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT

onready var _area := $Area2D

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_timeout")
	$AnimationPlayer.play("fly")
	$Sprite.flip_h = direction == Vector2.LEFT
	_velocity = Vector2(speed * direction.x, 0)

func _physics_process(delta: float) -> void:
	_velocity = move_and_slide(_velocity)
	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)

func _on_timeout() -> void:
	queue_free()
