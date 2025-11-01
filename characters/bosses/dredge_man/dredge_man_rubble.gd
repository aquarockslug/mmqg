extends RigidBody2D

export(int) var rubble_y := 760
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
	$Timer.connect("timeout", self, "_on_timeout")

	rng.randomize()
	var rock_type = ["rock1", "rock2", "rock3", "rock4"][rng.randi_range(0, 3)]
	$AnimationPlayer.play(rock_type)

func _physics_process(delta: float) -> void:
	rotation = 0

	# hit player and count bounces
	if not _area.monitoring: return
	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)
			bounces += 1
		elif body is TileMap:
			bounces += 1

	# limit the number of times it can hit the stage tiles
	if bounces >= max_bounces:
		_area.monitoring = false
		$Timer.start()

func _on_timeout():
	queue_free()

func fling(power = 1) -> void:
	apply_central_impulse(Vector2(randf() * distance * direction.x, -height * power))

func drop(rubble_x = 2680, spread = 50):
	rubble_x = rubble_x + rng.randi_range(-spread, spread)
	self.global_position = Vector2(rubble_x, rubble_y)
