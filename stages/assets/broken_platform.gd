extends KinematicBody2D

# change in y position per frame while falling
export(float) var fall_speed = 4

# plays the shake animation
onready var _animation_player: AnimationPlayer = $AnimationPlayer

var triggered = false
var target_y = 0

func _ready():
	$Trigger.connect("body_entered", self, "_on_body_entered")
	_animation_player.connect("animation_finished", self, "_on_animation_finished")
	target_y = position.y
	
func _process(delta):
	# if triggered, not shaking, and it is above the target, move towards the target
	if triggered && not _animation_player.is_playing() && position.y < target_y:
		position.y += fall_speed
	
func _on_body_entered(body):
	if body.name == "Player" || body.name == "Rock": _on_trigger()
	
# move the target_y after every shakes
func _on_animation_finished(anim_name):
	if anim_name == "shake": target_y += 16
		
func _on_trigger():
	_animation_player.play("shake")
	triggered = true
