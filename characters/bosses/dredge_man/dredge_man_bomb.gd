extends KinematicBody2D

onready var _timer_fuse: Timer = $TimerBombFuse

export(int) var damage := 1
export(int) var explosion_frame_count := 10
export(int) var explosion_scale := 4

var _velocity: Vector2
var direction := Vector2.RIGHT

var exploded = false
var frames_since_exploded = 0

onready var _area := $Area2D

func _ready() -> void:
	_timer_fuse.one_shot = true
	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()
	$AnimationPlayer.play("drop")
	$Sprite.flip_h = direction == Vector2.RIGHT
	_velocity = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if exploded:
		if frames_since_exploded >= explosion_frame_count: queue_free()
		frames_since_exploded += 1
	else:
		_velocity.y += Constants.GRAVITY
		_velocity = move_and_slide(_velocity)

	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)
			if not exploded: _on_explode()

func _on_explode():
	exploded = true
	_timer_fuse.stop()
	$AnimationPlayer.play("explode")
	self.scale = Vector2(explosion_scale, explosion_scale)

