extends State

const VELOCITY: int = 24
const SLEEP_RADIUS: int = 24

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

func _ready() -> void:
	$"../../SleepTimer".connect("timeout", self, "_on_sleep_timeout")
	_animations.connect("animation_finished", self, "_on_animation_finished")

func _enter() -> void:
	$"../../SleepTimer".start()
	$"../../HitBox".monitoring = true
	_animations.play("wake")

func _update(delta: float) -> void:
	if _animations.current_animation == "flap":
		owner.move_and_slide(move_direction() * VELOCITY, Vector2.UP)

func _on_animation_finished(anim_name):
	if anim_name == "wake": _animations.play("flap")

func _on_sleep_timeout():
	if owner.global_position.distance_to(Global.player.global_position) > SLEEP_RADIUS:
		emit_signal("finished", "retreat")

func move_direction():
	if Global.player:
		# TODO stop moving if at almost the same position as player
		var target = Global.player.global_position
		if owner.global_position.distance_to(target) < 1: return Vector2.ZERO
		owner.flip_direction = target.x > owner.global_position.x
		return owner.global_position.direction_to(target)
	else:
		return Vector2.ZERO
