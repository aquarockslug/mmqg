extends State

func _ready():
	$"../../EnemyAnimations".connect("animation_finished", self, "_after_shooting")

func _enter():
	$"../../EnemyAnimations".play("shoot")
	owner.is_blocking = false

func _after_shooting(anim_name):
	if anim_name != "shoot": return
	emit_signal("finished", "hide")
