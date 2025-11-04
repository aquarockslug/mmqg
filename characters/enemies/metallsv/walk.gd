extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

var _velocity: Vector2 = Vector2(0, 0)
var speed = 1000 
var gravity_scale = 5
var stuck_time = 0 # the number of _physics_processes spent being stuck
var turn_threshold = 30 # how long to be stuck before turning

func _ready():
	$"../../HideArea".connect("body_entered", self, "_hide_area_entered")
	$"../../HideArea".connect("body_exited", self, "_hide_area_exited")

func _enter():
	$"../../EnemyAnimations".play("walk")
	owner.is_blocking = false

func _hide_area_entered(body):
	if body is Player:
		emit_signal("finished", "hide") 

func _hide_area_exited(body):
	if body is Player:
		emit_signal("finished", "walk") 
		
func _process(delta):
	# count how many _physics_processes have been made while stuck
	if stuck(): stuck_time += 1
	
	# turn around if stuck for too long
	if stuck_time >= turn_threshold:
		owner.toggle_flip_h()
		stuck_time = 0

func _physics_process(delta: float) -> void:
	# only has x velocity while in the walking animation
	if _animations.current_animation == "walk":
		_velocity = owner.get_facing_direction() * speed * delta	
	else: 
		_velocity.x = 0
	
	_velocity.y += Constants.GRAVITY * gravity_scale
	_velocity = owner.move_and_slide(_velocity)
	
# true when trying to walk but a collision is preventing it
func stuck() -> bool: return _velocity.x == 0 && speed != 0 && _animations.current_animation == "walk"
