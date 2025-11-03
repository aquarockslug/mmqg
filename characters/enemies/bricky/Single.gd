extends State

func _enter():
	$"../../EnemyAnimations".play("single_idle")
	$"../../MiddleCollision".disabled = true
	$"../../HitBox/MiddleHitBox".disabled = true
