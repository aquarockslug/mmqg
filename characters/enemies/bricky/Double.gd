extends State

func _enter():
	$"../../EnemyAnimations".play("double_idle")
	$"../../TopCollision".disabled = true
	$"../../HitBox/TopHitBox".disabled = true

func _process(delta):
	if (owner._hit_points <= round(owner.hit_points_max * 0.33)):
		queue_free() # free this Double state so its _process doesnt interfere
		emit_signal("finished", "single")
