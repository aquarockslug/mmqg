extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter() -> void:
	_animations.play("move")
	owner.speed = owner.move_speed

func _process(delta: float) -> void:
	if owner.can_see_player(): emit_signal("finished", "rush")

func _physics_process(delta: float) -> void:
	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)
