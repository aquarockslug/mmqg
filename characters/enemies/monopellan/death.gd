extends State

# on death the propeller remains and flies upward off screen
# it holds the dropped power up if one does spawn

const Propeller: Resource = preload("res://characters/enemies/monopellan/Propeller.tscn")

onready var _animations: AnimationPlayer = $"../../BaseAnimations"
onready var _item_generator := $"../../ItemGenerator"

var prop

func _enter() -> void:
	_animations.play("death")
	break_propeller()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "death": owner.queue_free()

func break_propeller():
	prop = Propeller.instance()
	owner.get_parent().add_child(prop)
	prop.global_position = owner.global_position

