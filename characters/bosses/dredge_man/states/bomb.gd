extends "common.gd"

onready var _timer_drop: Timer = $"../../TimerDrop"
onready var _timer_turn: Timer = $"../../TimerTurn"
export(int) var jump_speed := -450
export(int) var horizontal_speed := 150

var landing = false

func _ready() -> void:
	_timer_drop.connect("timeout", self, "_on_drop")
	_timer_turn.connect("timeout", self, "_on_turn")

func _enter() -> void:
	landing = false
	velocity.x = 0
	owner._animation.play("jump")
	yield(owner._animation, "animation_finished")
	owner._animation.play("bomb")
	_timer_drop.start()
	velocity.x = owner.get_facing_direction().x * horizontal_speed
	velocity.y = jump_speed
	yield(owner._animation, "animation_finished")
	landing = true

func _update(delta: float) -> void:

	velocity.y = clamp(velocity.y + Constants.GRAVITY, -Constants.FALL_SPEED_MAX, Constants.FALL_SPEED_MAX)
	owner.move_and_slide(velocity, Constants.FLOOR_NORMAL)

	if owner.is_on_floor() and landing:
		$"../../CharacterSprites/DredgeToss".flip_h = owner.get_facing_direction().x < 0
		emit_signal("finished", "idle")

# dredge man lets go of the bomb while jumping
func _on_drop() -> void:
	_timer_drop.stop()
	var bomb := Bomb.instance()
	bomb.direction = owner.get_facing_direction()
	if not owner.is_restarting:
		owner.get_parent().add_child(bomb)
		bomb.global_position = owner.global_position + Vector2(
			_dig_pos.position.x * owner.get_facing_direction().x * -1,
			_dig_pos.position.y
		)
