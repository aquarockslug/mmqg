extends RigidBody2D

onready var _anim: AnimationPlayer = $AnimationPlayer

export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT
var bounces = 0
var max_bounces = 2

onready var _area := $Area2D

func _ready() -> void:
	$CollisionDeactivateTimer.connect("timeout", self, "deactivate_collision")
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_camera_exited")

	# pick a random animation to play
	_anim.play(Array(_anim.get_animation_list()).pick_random())
	set_physics_process(false)

# the collision shape has to be disabled slightly after the stage collision so it bounces
func deactivate_collision() -> void: $CollisionShape2D.disabled = true

func fling(power = 1, fling_distance = 200, height = 550) -> void:
	set_physics_process(true)
	apply_central_impulse(Vector2(randf() * fling_distance * direction.x, -height * power))

func drop() -> void:
	set_physics_process(true)

func _camera_exited(): queue_free()

func _physics_process(delta: float) -> void:
	rotation = 0
	if not _area.monitoring: return

	# hit player and count bounces
	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)
			bounces += 1
		elif body is TileMap:
			bounces += 1

	# limit the number of times it can hit the stage tiles before being deactivated
	if bounces >= max_bounces:
		_area.monitoring = false
		$CollisionDeactivateTimer.start()
