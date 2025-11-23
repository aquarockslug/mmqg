extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _state_machine: StateMachine = $"../../StateMachine"
onready var _walk_duration_timer: Timer = $"../../WalkDurationTimer"

var _velocity: Vector2 = Vector2(0, 0)
var speed = 1500
var gravity_scale = 2
var stuck_time = 0 # the number of _physics_processes spent being stuck
var turn_threshold = 30 # how long to be stuck before turning

func _ready():
	_walk_duration_timer.connect("timeout", self, "_walk_duration_timeout")

func _enter():
	## owner.set_flip_direction(Global.get_player().global_position.x > owner.global_position.x)
	$"../../EnemyAnimations".play("walk")
	owner.is_blocking = false
	_walk_duration_timer.start()

func _process(delta):
	# count how many _physics_processes have been made while stuck
	if is_stuck(): stuck_time += 1

	# turn around if stuck for too long
	if stuck_time >= turn_threshold:
		owner.toggle_flip_h()
		stuck_time = 0

func _physics_process(delta: float) -> void:
	if is_walking() and not is_falling():
		_velocity = owner.get_facing_direction() * speed * delta
	else:
		_velocity.x = 0

	_velocity.y += Constants.GRAVITY * gravity_scale
	_velocity = owner.move_and_slide(_velocity)

# true when trying to walk but a collision is preventing it
func is_stuck() -> bool: return _velocity.x == 0 && speed != 0 && _animations.current_animation == "walk"
func is_walking() -> bool: return _state_machine.current_state.name == "Walk"
func is_falling() -> bool: return _velocity.y != 0

func _walk_duration_timeout() -> void:
	_walk_duration_timer.stop()
	emit_signal("finished", "hide")
