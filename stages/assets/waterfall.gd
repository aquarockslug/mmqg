extends Area2D

export(float) var water_power := 0.75

onready var _jumping_player: State = $"../../../Player/StateMachine/Jump"
onready var _sfx: AudioStreamPlayer = $SplashSound
onready var _splash_sprite: Sprite = $SplashSprite # TODO use an AnimatedSprite

var is_splashing = false
var player = null
var splash_position = Vector2(0, -13)
var animation_frame_duration = 0.1

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	_splash_sprite.visible = false

func _process(delta):
	if is_splashing and player:

		# update the position and direction of the splash sprite
		var new_splash_position = player.global_position + splash_position
		_splash_sprite.global_position = new_splash_position
		_splash_sprite.flip_h = player.get_facing_direction().x > 0

		# add downward velocity to the jumping player state
		_jumping_player.velocity.y += water_power * delta * 1000


func _on_body_entered(body):
	if not body is Player: return
	else: player = body as Player

	is_splashing = true
	_splash_sprite.visible = true

	# animate splash sprite while splashing
	while is_splashing:
		_sfx.play()
		_splash_sprite.frame = 0 if _splash_sprite.frame else 1
		yield(get_tree().create_timer(animation_frame_duration), "timeout")

func _on_body_exited(body):
	if body is Player:
		is_splashing = false
		_splash_sprite.visible = false
