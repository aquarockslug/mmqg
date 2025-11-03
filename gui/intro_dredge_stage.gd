extends Control

var path = "res://stages/dredge/dredge_stage.tscn"

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "start_stage")
	$AnimationPlayer.play("intro")
	$FadeEffects.fade_in(0.5)

func start_stage(anim_name) -> void:
	$FadeEffects.fade_out(0.5)
	yield($FadeEffects, "screen_faded_out")
	Global.main_scene.switch_scene(path)

