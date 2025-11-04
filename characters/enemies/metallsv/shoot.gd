extends State

const SHOOT_DELAY: float = 0.3
const Bullet: Resource = preload("EnemyMetallsvBullet.tscn")

func _ready():
	$"../../EnemyAnimations".connect("animation_finished", self, "_after_shooting")

func _enter():
	owner.is_blocking = false
	owner.set_flip_direction(Global.get_player().position.x > owner.position.x)
	$"../../EnemyAnimations".play("shoot")
	yield(owner.start_yield_timer(SHOOT_DELAY), "timeout")

	if owner.is_dead: return

	shoot()

func shoot():
	var bullet_pos: Vector2 = $"../../HitBox".global_position
	var bullet: Node = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = owner.get_facing_direction()
	Global.get_current_stage().add_child(bullet)

	bullet = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = Vector2.DOWN + owner.get_facing_direction()
	Global.get_current_stage().add_child(bullet)

	bullet = Bullet.instance()
	bullet.position = bullet_pos
	bullet.direction = Vector2.UP + owner.get_facing_direction()
	Global.get_current_stage().add_child(bullet)

func _after_shooting(anim_name):
	if anim_name == "shoot":
		emit_signal("finished", "hide")
