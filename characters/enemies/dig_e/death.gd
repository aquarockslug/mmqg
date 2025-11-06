extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter() -> void:
	_animations.play("explode")
	_animations.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "explode": owner.queue_free()
