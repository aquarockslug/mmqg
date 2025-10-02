extends State

var _velocity: Vector2

export(int) var init_drop_velocity := 250

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _inputs: InputHandler = $"../../Inputs"

func _enter() -> void:
	_animations.play("drop")
	_velocity.y = init_drop_velocity

func _physics_process(delta: float) -> void:
	_velocity.y +=  Constants.GRAVITY
	_velocity = owner.move_and_slide(_velocity)

	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)

	if _velocity.y <= 1:
		emit_signal("finished", "armed")
