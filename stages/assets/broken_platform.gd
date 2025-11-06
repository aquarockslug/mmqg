extends KinematicBody2D

export(bool) var keep_falling = true

# plays the shake animation
onready var _animation_player: AnimationPlayer = $AnimationPlayer

# change in y position per frame while falling
var fall_speed = 4
var triggered = false
var target_y = 0
var init_y = 0

func _ready():
	$Trigger.connect("body_entered", self, "_on_body_entered_trigger")
	get_parent().connect("transition_entered", self, "reset")
	_animation_player.connect("animation_finished", self, "_on_animation_finished")
	$PreciseVisibilityNotifier2D.connect("camera_exited", self, "_on_exit_screen")
	target_y = position.y
	init_y = position.y

func _process(delta):
	# if triggered, not shaking, and it is above the target, move towards the target
	if triggered && not _animation_player.is_playing() && position.y < target_y:
		position.y += fall_speed

	# automatically trigger again when the target is reached
	if keep_falling and triggered and position.y == target_y:
		_animation_player.play("shake")

func _on_body_entered_trigger(body):
	if body.name == "Player" || body.name == "Rock": _on_trigger()

# move the target_y after every shakes
func _on_animation_finished(anim_name):
	if anim_name == "shake": target_y += 16

func _on_trigger():
	_animation_player.play("shake")
	triggered = true

func reset(transition):
	position.y = init_y
	target_y = init_y
	triggered = false
	call_deferred("set_active", true)

func _on_exit_screen():
	if triggered: call_deferred("set_active", false)

func set_active(is_active):
	$Sprite.visible = is_active
	$Collider.disabled = not is_active
