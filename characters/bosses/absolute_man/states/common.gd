extends State

const COOLDOWN: float = 2.0

var velocity := Vector2()

onready var timer_cooldown: Timer = $"../../TimerCooldown"

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_debug_01"):
		pass

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "hit":
		owner.is_invincible = false

func jump() -> void:
	if owner.is_on_floor() and timer_cooldown.is_stopped():
		timer_cooldown.start(COOLDOWN + randf() * 0.6)
		emit_signal("finished", "jump")
	else:
		emit_signal("finished", "idle")


