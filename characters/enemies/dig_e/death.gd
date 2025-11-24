extends State

export(int) var explosion_scale := 4
onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

func _enter() -> void:
	owner._player_collision_area.scale = Vector2(explosion_scale, explosion_scale)
	$"../../SFX/Explode".play()
	_animations.play("explode")
	_animations.connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "explode": owner.call_deferred("queue_free")
