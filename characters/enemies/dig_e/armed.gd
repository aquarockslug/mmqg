extends State

var _velocity: Vector2

export(int) var explosion_frame_count := 25

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("armed")

func _physics_process(delta: float) -> void:
	# keep using gravity in case it was armed above the ground
	_velocity.y +=  Constants.GRAVITY * delta
	_velocity = owner.move_and_slide(_velocity)

func _update(delta) -> void:
	# explode on contact with player
	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: 
			owner._on_explode()

	# explode when fuse runs out
	if not owner.exploded and owner._timer_fuse.time_left < 1: owner._on_explode()

