extends State

var player
var player_in_range = false

func _ready():
	$"../../Timer".connect("timeout", self, "_ready_to_shoot")
	$"../../ShootArea".connect("body_entered", self, "_shoot_area_entered")
	$"../../ShootArea".connect("body_exited", self, "_shoot_area_exited")

func _enter():
	$"../../Timer".start()
	$"../../EnemyAnimations".play("hide")
	owner.is_blocking = true

func _ready_to_shoot():
	$"../../Timer".stop()
	if player_in_range:
		emit_signal("finished", "shoot")

func _shoot_area_exited(body):
	if body is Player:
		player = null
		player_in_range = false

func _shoot_area_entered(body):
	if body is Player:
		player = body as Player
		player_in_range = true
