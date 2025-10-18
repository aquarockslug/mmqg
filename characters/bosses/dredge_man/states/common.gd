extends State

const COOLDOWN: float = 2.0

var velocity := Vector2()

onready var _ray_cast: RayCast2D = $"../../RayCast2D"
onready var _ray_cast_length: float = _ray_cast.cast_to.length()
onready var _dig_pos: Position2D = $"../../PositionDig"
onready var timer_cooldown: Timer = $"../../TimerCooldown"

onready var effects: AnimationPlayer = $"../../AnimationEffects"

const Rubble: Resource = preload("res://characters/bosses/dredge_man/dredgeManRubble.tscn")
const Shovel: Resource = preload("res://characters/bosses/dredge_man/dredgeManShovel.tscn")
const Bomb: Resource = preload("res://characters/bosses/dredge_man/dredgeManBomb.tscn")

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

func scatter_rubble(power = 1) -> void:
	var rubble := Rubble.instance()
	rubble.direction = owner.get_facing_direction()
	owner.get_parent().add_child(rubble)
	rubble.global_position = owner.global_position + Vector2(
		_dig_pos.position.x * owner.get_facing_direction().x,
		_dig_pos.position.y
	)
	rubble.fling(power)

func drop_rubble() -> void:
	var rubble := Rubble.instance()
	rubble.drop()
