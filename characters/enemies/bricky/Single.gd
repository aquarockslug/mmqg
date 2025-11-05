extends State

func _enter():
	$"../../EnemyAnimations".play("single_idle")
	
	$"../../TopCollision".disabled = true
	$"../../HitBox/TopHitBox".disabled = true
	$"../../MiddleCollision".disabled = true
	$"../../HitBox/MiddleHitBox".disabled = true
