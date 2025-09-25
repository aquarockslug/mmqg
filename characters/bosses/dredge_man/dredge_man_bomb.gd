extends KinematicBody2D

const Rubble: Resource = preload("res://characters/bosses/dredge_man/dredgeManRubble.tscn")
onready var _timer_fuse: Timer = $TimerBombFuse
onready var _area := $Area2D

export(int) var damage := 1
export(int) var explosion_frame_count := 25
export(int) var explosion_scale := 3
export(int) var rubble_y := 720

var _velocity: Vector2
var direction := Vector2.RIGHT

var exploded = false
var frames_since_exploded = 0
var rubble_spread = 50
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	_timer_fuse.one_shot = true
	_timer_fuse.connect("timeout", self, "_on_explode")
	_timer_fuse.start()
	rng.randomize()
	$AnimationPlayer.play("drop")
	$Sprite.flip_h = direction == Vector2.RIGHT
	_velocity = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if not exploded:
		_velocity.y += Constants.GRAVITY
		_velocity = move_and_slide(_velocity)
	for body in _area.get_overlapping_bodies():
		if body is Player: body.on_hit(damage)
		if not exploded: _on_explode()

func _process(delta) -> void:
	if exploded:
		frames_since_exploded += 1
		if frames_since_exploded >= explosion_frame_count:
			drop_rubble(); drop_rubble()
			queue_free()

func drop_rubble():
	var rubble := Rubble.instance()
	self.get_parent().add_child(rubble)
	var rubble_x = self.global_position.x + rng.randi_range(-rubble_spread, rubble_spread)
	rubble.global_position = Vector2(rubble_x, rubble_y)

func _on_explode():
	exploded = true
	_timer_fuse.stop()
	$Sprite.visible = false
	$AnimationPlayer.play("explode")
	$Area2D.scale = Vector2(explosion_scale, explosion_scale)
	#get_tree().create_timer(1.0).timeout.connect(self.drop_rubble)

