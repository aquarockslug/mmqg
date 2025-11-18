extends RigidBody2D

onready var _anim: AnimationPlayer = $AnimationPlayer

export(int) var damage := 3

var direction := Vector2.LEFT
var bounces = 0
var max_bounces = 2
var static_angle = 0

onready var _area := $Area2D
onready var _sprite := $Sprite

func _ready() -> void:
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_on_camera_exited")
	set_physics_process(false)

	# pick a random animation to play
	randomize()
	static_angle = [
		Vector2.UP.angle(),
		Vector2.RIGHT.angle(),
		Vector2.DOWN.angle(),
		Vector2.LEFT.angle()
	].pick_random()
	_anim.play(Array(_anim.get_animation_list()).pick_random())

func fling(power = 1, fling_distance = 200, height = 550) -> void:
	_sprite.visible = true
	set_physics_process(true)
	apply_central_impulse(Vector2(randf() * fling_distance * direction.x, -height * power))

func drop(new_anim = "random") -> void:
	if new_anim != "random": _anim.play(new_anim)
	_sprite.visible = true
	set_physics_process(true)

func _on_camera_exited():
	# only free after bouncing so when the starting position is off screen it isnt freed early
	if not _area.monitoring: queue_free()

func _physics_process(delta: float) -> void:
	rotation = static_angle

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
