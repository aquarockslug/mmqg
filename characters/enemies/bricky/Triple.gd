extends State


func _enter():
	$"../../TopCollision".disabled = false
	$"../../HitBox/TopHitBox".disabled = false
	$"../../MiddleCollision".disabled = false
	$"../../HitBox/MiddleHitBox".disabled = false
	$"../../EnemyAnimations".play("triple_idle")

func _process(delta):
	if (owner._hit_points == round(owner.hit_points_max * 0.66)):
		emit_signal("finished", "double")
