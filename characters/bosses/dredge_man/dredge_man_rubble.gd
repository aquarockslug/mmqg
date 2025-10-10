extends KinematicBody2D

export(int) var rubble_y := 760
export(int) var height := 550
export(int) var distance := 200
export(int) var damage := 3

var _velocity: Vector2
var direction := Vector2.LEFT
var rng = RandomNumberGenerator.new()

onready var _area := $Area2D

func _ready() -> void:
	$Timer.connect("timeout", self, "_on_timeout")
	var rock_type = ["rock1", "rock2", "rock3", "rock4"].pick_random()
	$AnimationPlayer.play(rock_type)
	rng.randomize()

func _physics_process(delta: float) -> void:
	_velocity.y += Constants.GRAVITY
	_velocity = move_and_slide(_velocity)

	for body in _area.get_overlapping_bodies():
		if body is Player:
			body.on_hit(damage)

func _on_timeout() -> void:
	queue_free()

func fling(power = 1) -> void:
	_velocity = Vector2(randf() * distance * direction.x, -height * power)

func drop(rubble_x = 2680, spread = 50):
	rubble_x = rubble_x + rng.randi_range(-spread, spread)
	self.global_position = Vector2(rubble_x, rubble_y)
