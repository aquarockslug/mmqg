extends KinematicBody2D

onready var _timer_fuse: Timer = $TimerBombFuse
export(int) var damage := 1

var _velocity: Vector2
var direction := Vector2.RIGHT

onready var _area := $Area2D

func _ready() -> void:
	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()
	$AnimationPlayer.play("drop")
	$Sprite.flip_h = direction == Vector2.RIGHT
	_velocity = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	_velocity.y += Constants.GRAVITY
	_velocity = move_and_slide(_velocity)

	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)

func _on_explode():
	# TODO create a large hitbox and sprite
	_timer_fuse.stop()
	queue_free()
