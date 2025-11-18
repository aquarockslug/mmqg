extends RigidBody2D

onready var _anim: AnimationPlayer = $AnimationPlayer

export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT
var bounces = 0
var max_bounces = 2

onready var _area := $Area2D
onready var _sprite := $Sprite

func _ready() -> void:
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_on_camera_exited")
	_sprite.visible = false
	set_physics_process(false)

	# pick a random animation to play
	_anim.play(Array(_anim.get_animation_list()).pick_random())

func fling(power = 1, fling_distance = 200, height = 550) -> void:
	_sprite.visible = true
	set_physics_process(true)
	apply_central_impulse(Vector2(randf() * fling_distance * direction.x, -height * power))

func drop() -> void:
	_sprite.visible = true
	set_physics_process(true)

func _on_camera_exited(): queue_free()

func _physics_process(delta: float) -> void:
	rotation = 0

	# hit player and count bounces
	if _area.monitoring:
		for body in _area.get_overlapping_bodies():
			if body is Player:
				body.on_hit(damage)
				bounces += 1
			elif body is TileMap:
				bounces += 1

	# limit the number of times it can hit the stage tiles before being deactivated
	if bounces >= max_bounces:
		_area.monitoring = false
		# the collision shape has to be disabled slightly after so it bounces
		yield(get_tree().create_timer(0.2), "timeout")
		$CollisionShape2D.disabled = true
