extends State

const SHOOT_DELAY: float = 0.3
const Bullet: Resource = preload("EnemyMetallsvBullet.tscn")

func _ready():
	$"../../EnemyAnimations".connect("animation_finished", self, "_after_shooting")

func _enter():
	owner.is_blocking = false
	if Global.get_player():
		owner.set_flip_direction(Global.get_player().global_position.x > owner.global_position.x)
	$"../../EnemyAnimations".play("shoot")
	yield(owner.start_yield_timer(SHOOT_DELAY), "timeout")

	if owner.is_dead: return

	call_deferred("shoot")
	
func shoot():
	var bullet_pos: Vector2 = $"../../HitBox".global_position
	var bullet: Node = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = owner.get_facing_direction()
	Global.get_current_stage().call_deferred("add_child", bullet)

	bullet = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = Vector2.DOWN + owner.get_facing_direction()
	Global.get_current_stage().call_deferred("add_child", bullet)

	bullet = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = Vector2.UP + owner.get_facing_direction()
	Global.get_current_stage().call_deferred("add_child", bullet)

func _after_shooting(anim_name):
	if anim_name == "shoot":
		emit_signal("finished", "walk")
