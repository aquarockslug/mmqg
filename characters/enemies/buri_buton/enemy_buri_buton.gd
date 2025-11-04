extends "res://characters/enemies/base/enemy_base.gd"

var _velocity: Vector2 = Vector2(0, 0)
onready var _ray: RayCast2D = $"Collider/LineOfSite"

export(int) var move_speed := 1000
export(int) var damage := 2
export(int) var gravity_scale := 5

var speed = 1000 # the current speed
var stuck_time = 0 # the number of _physics_processes spent being stuck
var turn_threshold = 30 # how long to be stuck before turning

func _physics_process(delta: float) -> void:
	_velocity = get_facing_direction() * speed * delta
	_velocity.y += Constants.GRAVITY * gravity_scale
	_velocity = move_and_slide(_velocity)
	
	# dont move forward while falling
	if falling(): 
		speed = 0
		_velocity.x = 0 
		
func _process(delta: float) -> void:
	# count how many _processes have been made while stuck
	if stuck(): stuck_time += 1
		
	# turn around if stuck for too long
	if stuck_time >= turn_threshold:
		turn_around()
		stuck_time = 0

# true when in the air with velocity on the y axis
func falling() -> bool: return _velocity.y != 0 && not is_on_floor()

# true when trying to move but a collision is preventing it
func stuck() -> bool: return _velocity.x == 0 && speed != 0

func turn_around() -> void:
	toggle_flip_h()
	_ray.cast_to.x *= -1

func can_see_player() -> bool:
	return _ray.is_colliding()
