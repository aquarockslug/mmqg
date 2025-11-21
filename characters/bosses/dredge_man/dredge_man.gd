extends KinematicBody2D

export(int) var contact_damage := 3
export(int) var buster_damage := 3

var _hit_points: int
var _start_pos: Vector2
var _is_blocking: bool
var _is_collidable: bool
var is_invincible: bool
var is_dead: bool
var is_restarting: bool

onready var _base_width: int = Global.base_size.x
onready var _sprite: Sprite = $"CharacterSprites/Sprite"
onready var _animation: AnimationPlayer = $AnimationBase
onready var life_bar: Control = Global.get_current_stage().get_node("GUI/MarginContainer/LifeEnergyBar/BossBar")

const BigRubble: Resource = preload("res://characters/bosses/dredge_man/dredgeManBigRubble.tscn")

signal change_state(state_name)
signal hit_points_changed(_hit_points)
signal boss_ready()
signal boss_died()

func toggle_flip_h() -> void:
	$Sprite.flip_h = !$Sprite.flip_h

func _ready() -> void:
	connect("change_state", $StateMachine, "_change_state")
	connect("hit_points_changed", life_bar, "on_hit_points_changed")
	$Area2D.connect("body_entered", self, "_on_hit")
	_start_pos = global_position

func reset() -> void:
	$"../DredgeRope".visible = false
	$"../DredgeBag".visible = false
	$"../ExplodingBlock".visible = true
	$"../ExplodingBlock".play("default")
	$"CharacterSprites/Sprite".visible = false
	is_restarting = true
	emit_signal("change_state", "await")
	$StateMachine.set_active(false)
	visible = true
	is_dead = false
	life_bar.visible = false
	_hit_points = Constants.HIT_POINTS_MAX
	global_position = _start_pos
	is_invincible = true
	_is_blocking = false
	_is_collidable = true

func defer_rubble(offset, anim):
	var rubble := BigRubble.instance()
	owner.get_parent().add_child(rubble)
	rubble.global_position = global_position + offset
	rubble.apply_central_impulse(Vector2(-randf() * 65, 25))
	rubble.drop(anim) # override the random animation with the large stone block rubble
	
func intro_rubble(offset: Vector2, anim: String = "rock3") -> void:
	call_deferred("defer_rubble", offset, anim)

func play_intro_sequence() -> void:
	# blow up large blocks
	$SFX/Explosion.play()
	$"../ExplodingBlock".play("explode")
	intro_rubble(Vector2(-18, -160))
	intro_rubble(Vector2(18, -160))
	yield(get_tree().create_timer(0.1), "timeout") # delay to stagger drops

	# more rubble follows
	intro_rubble(Vector2(0, -180), "random")
	intro_rubble(Vector2(18, -220), "random")

func on_boss_entered() -> void:
	play_intro_sequence()
	Global.get_player().disable_controls(2)
	yield(get_tree().create_timer(1.75), "timeout") # rubble needs time to drop because physics turn off after this
	$StateMachine.initialize($"StateMachine/Ready".get_path())

func _physics_process(delta: float) -> void:
	if $Area2D:
		for body in $Area2D.get_overlapping_bodies():
			if body is Player and _is_collidable:
				body.on_hit(contact_damage)

func _on_hit(body: PhysicsBody2D) -> void:
	# make sure that the body is a weapon and not the player
	if body and body.is_in_group("PlayerWeapons"):
		if is_invincible: 
			body.queue_free()
		elif _is_blocking:
			body.reflect()
		else:
			is_invincible = true
			$"SFX/Hit".play()
			body.queue_free()
			$AnimationHit.play("hit")
			_take_damage(buster_damage)

func _take_damage(damage: int) -> void:
	_hit_points -= damage
	emit_signal("hit_points_changed", _hit_points)
	if _hit_points < 1:
		die()

func _switch_side() -> void:
	global_position.x -= (global_position - \
			Global.get_current_stage().get_current_camera().get_camera_screen_center()).x * 2
	if get_facing_direction() == Vector2.RIGHT:
		set_facing_direction(Vector2.LEFT)
	else:
		set_facing_direction(Vector2.RIGHT)

func die() -> void:
	is_dead = true
	visible = false
	_is_collidable = false
	emit_signal("change_state", "death")
	emit_signal("boss_died")

func set_facing_direction(dir: Vector2) -> void:
	_sprite.flip_h = true if dir == Vector2.LEFT else false

func get_facing_direction() -> Vector2:
	return Vector2.LEFT if _sprite.flip_h else Vector2.RIGHT

func face_player() -> void:
	if Global.player is Player:
		set_facing_direction(Vector2(sign(Global.player.global_position.x - global_position.x), 0))
