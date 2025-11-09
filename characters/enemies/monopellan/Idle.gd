extends State

const SHOOT_DELAY = 0.2
const Bullet: Resource = preload("EnemyMonopellanBullet.tscn")

onready var _animations = $"../../EnemyAnimations"

var speed = 15
var movement_range = 30
var movement_center
var prev_side = true

func _ready():
	movement_center = owner.position
	$"../../ShootTimer".connect("timeout", self, "shoot")
	_animations.connect("animation_finished", self, "_on_animation_ended")

func _enter():
	_animations.play("aim_forward")

func _update(delta):
	var player_on_left_side = abs(angle_to_player()) < 90
	if prev_side != player_on_left_side: _animations.play("rotate")
	prev_side = player_on_left_side


func _physics_process(delta):
	# set a position using a sin wave
	var center_offset = sin(Time.get_ticks_msec() * 0.0001 * speed) * movement_range
	owner.position.y = movement_center.y + center_offset

# aim and shoot a bullet at the player
func shoot():
	# dont shoot if the player is above the monopellan
	if sign(angle_to_player()) == 1: return
	var shoot_direction = aim(angle_to_player())

	yield(owner.start_yield_timer(SHOOT_DELAY), "timeout")

	var bullet: Node = Bullet.instance()
	bullet.position = $"../../HitBox".global_position + (shoot_direction * Vector2(10, 10))
	bullet.direction = shoot_direction
	Global.get_current_stage().add_child(bullet)

# point sprite towards the player and return the direction to fire in
func aim(angle):
	$"../../Sprite".flip_h = angle < -90

	var animation_name
	var shoot_angle
	if angle > -30 or angle < -150:
		animation_name = "aim_forward"
		shoot_angle = owner.get_facing_direction()
	elif angle > -60 or angle < -120:
		animation_name = "aim_angled"
		shoot_angle = Vector2(owner.get_facing_direction().x, 1)
	else:
		animation_name = "aim_down"
		shoot_angle = Vector2(0, 1)

	_animations.play(animation_name)

	return shoot_angle

func angle_to_player():
	return rad2deg(owner.position.angle_to_point(Global.get_player().position))

func _on_animation_ended(anim_name):
	if anim_name == "rotate":
		print("flip and angled")
		owner.toggle_flip_h()
		_animations.play("aim_down")
