extends KinematicBody2D

var _velocity = Vector2(10, 0)

func _ready():
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_on_camera_exit")

func _process(delta):
	_velocity.y += -5
	move_and_slide(_velocity)

func _on_camera_exit():
	queue_free()
