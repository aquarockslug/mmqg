extends State

const VELOCITY: int = 24

var _rotating_left: bool

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter() -> void:
	_animations.play("wake")
	_animations.connect("animation_finished", self, "_on_animation_finished")

func _update(delta: float) -> void:
	if _animations.current_animation == "flap":
		owner.move_and_slide(move_direction() * VELOCITY, Vector2.UP)

func _on_animation_finished(anim_name):
	_animations.play("flap")

func move_direction():
	if Global.player:
		var target = Vector2(Global.player.global_position.x, Global.player.global_position.y)
		owner.flip_direction = target.x > owner.global_position.x
		return owner.global_position.direction_to(target)
	else:
		return Vector2.ZERO
