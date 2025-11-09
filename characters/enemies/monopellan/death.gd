extends State

# on death the propeller remains and flies upward off screen
# it holds the dropped power up if one does spawn

onready var _animations: AnimationPlayer = $"../../BaseAnimations"
onready var _item_generator := $"../../ItemGenerator"

func _enter() -> void:
	_animations.play("death")
	break_propeller()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		# on the monopellan the propeller drops the item
		owner.queue_free()

func break_propeller():
	pass
	# instance the propeller scene

	# add the dropped item as a child of the propeller
	_item_generator.drop_item()

