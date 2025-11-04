extends State

onready var _animations: AnimationPlayer = $"../../EnemyAnimations"

var _velocity: Vector2 = Vector2(0, 0)
var speed = 1000 
var gravity_scale = 5

func _ready():
	$"../../HideArea".connect("body_entered", self, "_hide_area_entered")
	$"../../HideArea".connect("body_exited", self, "_hide_area_exited")

func _enter():
	$"../../EnemyAnimations".play("walk")
	owner.is_blocking = false

func _hide_area_entered(body):
	if body is Player:
		emit_signal("finished", "hide") 

func _hide_area_exited(body):
	if body is Player:
		emit_signal("finished", "walk") 

func _physics_process(delta: float) -> void:
	if _animations.current_animation == "walk":
		_velocity = owner.get_facing_direction() * speed * delta
	else: _velocity.x = 0
	
	_velocity.y += Constants.GRAVITY * gravity_scale
	_velocity = owner.move_and_slide(_velocity)
	
