extends "res://characters/enemies/base/enemy_base.gd"

var _velocity: Vector2 = Vector2(0, 0)
onready var _ray: RayCast2D = $"Collider/LineOfSite"

export(int) var move_speed := 1000
export(int) var damage := 2
export(int) var gravity_scale := 4

var speed := 1000
func _physics_process(delta: float) -> void:
	_velocity = get_facing_direction() * speed * delta
	_velocity.y += Constants.GRAVITY * gravity_scale
	_velocity = move_and_slide(_velocity)
	
	# dont move forward while falling
	if falling(): speed = 0 
	
	# turn around if the path is being blocked
	if stuck(): turn_around()

# true when in the air with velocity on the y axis
func falling() -> bool: return _velocity.y != 0 && not is_on_floor()

# true when trying to move but a collision is preventing it
func stuck() -> bool: return abs(_velocity.x) < 1 && speed != 0

func turn_around() -> void:
	toggle_flip_h()
	_ray.cast_to.x *= -1

func can_see_player() -> bool:
	return _ray.is_colliding()
	
