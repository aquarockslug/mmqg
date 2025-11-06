extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _area: Area2D = $"../../TriggerArea"

func _ready():
	_area.connect("body_entered", self, "_on_trigger")

func _enter():
	_animations.play("hide")

func _on_trigger(body):
	if body is Player:
		if $"../../StateMachine".current_state.name != "Move":
			emit_signal("finished", "move")

