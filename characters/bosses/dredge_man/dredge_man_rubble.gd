extends RigidBody2D

export(int) var height := 550
export(int) var distance := 200
export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT
var rng = RandomNumberGenerator.new()
var bounces = 0
var max_bounces = 2

onready var _area := $Area2D

func _ready() -> void:
	$CollisionDeactivateTimer.connect("timeout", self, "deactivate_collision")
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_camera_exited")

	rng.randomize()
	var rock_type = ["rock1", "rock2", "rock3", "rock4"][rng.randi_range(0, 3)]
	$AnimationPlayer.play(rock_type)

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

# the collision shape has to be disabled slightly after the stage collision so it bounces
func deactivate_collision() -> void: $CollisionShape2D.disabled = true

func fling(power = 1) -> void:
	apply_central_impulse(Vector2(randf() * distance * direction.x, -height * power))
