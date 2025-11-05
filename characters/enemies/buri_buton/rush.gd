extends State

func _enter() -> void:
	$"../../EnemyAnimations".play("rush")
	owner.speed = owner.move_speed * 2.5

#func _process(delta: float) -> void:
#	if owner.stuck(): emit_signal("finished", "move")

func _physics_process(delta: float) -> void:
	for body in owner._player_collision_area.get_overlapping_bodies():
		if body is Player: body.on_hit(owner.damage)
