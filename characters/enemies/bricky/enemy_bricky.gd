extends "res://characters/enemies/base/enemy_base.gd"

func _ready():
	$HitBox.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if $StateMachine.current_state.name == "Triple":
		$EnemyAnimations.play("triple_shake")
	if $StateMachine.current_state.name == "Double":
		$EnemyAnimations.play("double_shake")
	if $StateMachine.current_state.name == "Single":
		$EnemyAnimations.play("single_shake")
