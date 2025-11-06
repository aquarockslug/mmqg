extends KinematicBody2D

onready var _timer_fuse: Timer = $TimerBombFuse
onready var _area := $Area2D

export(int) var damage := 2
export(int) var explosion_frame_count := 10
export(int) var explosion_scale := 3
export(int) var rubble_y := 720

var _velocity: Vector2
var direction := Vector2.RIGHT

var exploded = false
var frames_since_exploded = 0

func _ready() -> void:
	_timer_fuse.one_shot = true
	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()
	$AnimationPlayer.play("drop")
	$Sprite.flip_h = direction == Vector2.RIGHT
	_velocity = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if not exploded:
		_velocity.y += Constants.GRAVITY
		_velocity = move_and_slide(_velocity)

	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)
			_on_explode()
		elif not exploded:
			body.queue_free()
			_on_explode()

func _on_explode():
	exploded = true
	_timer_fuse.stop()
	$MineSFX.stop()
	$ExplodeSFX.play()
	$Sprite.visible = false
	$AnimationPlayer.play("explode")
	_area.scale = Vector2(explosion_scale, explosion_scale)
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

