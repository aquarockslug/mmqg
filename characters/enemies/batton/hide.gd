extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"
onready var _area: Area2D = $"../../TriggerArea"

func _ready():
	_area.connect("body_entered", self, "_on_trigger_enter")

func _enter():
	$"../../HitBox".monitoring = false
	_animations.play("hide")

func _on_trigger_enter(body):
	if body is Player:
		if $"../../StateMachine".current_state.name == "Hide":
			emit_signal("finished", "move")

