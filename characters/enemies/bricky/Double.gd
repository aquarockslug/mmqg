extends State

func _enter():
	$"../../EnemyAnimations".play("double_idle")
	$"../../TopCollision".disabled = true
	$"../../HitBox/TopHitBox".disabled = true

func _update(delta):
	if (owner._hit_points <= 3):
		queue_free() # free this Double state so its _process doesnt interfere
		emit_signal("finished", "single")
