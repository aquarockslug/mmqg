extends RigidBody2D

var bounces = 0
var max_bounces = 1

onready var _area := $Area2D

func _ready() -> void:
	$CollisionDeactivateTimer.connect("timeout", self, "deactivate_collision")
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_camera_exited")

func _camera_exited(): queue_free()

func _physics_process(delta: float) -> void:
	rotation = 0
	if not $CollisionDeactivateTimer.is_stopped(): return

	# hit player and count bounces
	for body in _area.get_overlapping_bodies():
		if body is TileMap: bounces += 1

	# limit the number of times it can hit the stage tiles before being deactivated
	if bounces >= max_bounces: $CollisionDeactivateTimer.start()

# the collision shape has to be disabled slightly after the stage collision so it bounces
func deactivate_collision() -> void: $CollisionShape2D.disabled = true

func set_direction(direction) -> void: $MaskSprite.flip_h = direction
