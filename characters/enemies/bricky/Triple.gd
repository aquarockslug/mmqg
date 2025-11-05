extends State


func _enter():
	$"../../TopCollision".disabled = false
	$"../../HitBox/TopHitBox".disabled = false
	$"../../MiddleCollision".disabled = false
	$"../../HitBox/MiddleHitBox".disabled = false
	$"../../EnemyAnimations".play("triple_idle")

func _update(delta):
	if (owner._hit_points <= 6):
		queue_free() # free this triple state so its _process doesnt interfere
		emit_signal("finished", "double")
