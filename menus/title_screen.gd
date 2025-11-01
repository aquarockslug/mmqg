extends Control

var main_buttons: Array
var new_game_button: Button
var options_button: Button
var exit_button: Button
var music_style_button: Button
var back_button: Button

func _ready() -> void:
	_create_main_buttons()
	if not OS.is_debug_build():
		$TitleMusic.play()

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton
		or event is InputEventKey or
		event is InputEventMouseButton) and not event.pressed:
		set_process_input(false)
		$"VBoxContainer/Buttons".remove_child($"VBoxContainer/Buttons/StartLabel")
		_show_main_buttons(new_game_button)

func _show_main_buttons(to_grab_focus) -> void:
	for button in main_buttons:
		$"VBoxContainer/Buttons".add_child(button)
	to_grab_focus.grab_focus()

func _new_game() -> void:
	for button in $"VBoxContainer/Buttons".get_children():
		button.disabled = true
	$TitleMusic.stop()
	$SelectSound.play()
	yield($SelectSound, "finished")
	$FadeEffects.fade_out(0.15)
	yield($FadeEffects, "screen_faded_out")
	Global.main_scene.switch_scene("res://menus/stage_select/StageSelect.tscn")

func _options() -> void:
	$SelectSound.play()
	_clear_buttons()
	_create_options_buttons()
	_show_main_buttons(music_style_button)

func _exit() -> void:
	exit_button.disconnect("focus_entered", self, "_on_focus_entered")
	exit_button.release_focus()
	$SelectSound.play()
	yield($SelectSound, "finished")
	get_tree().quit()

func _on_focus_entered(button: Button) -> void:
	if button: # Handle mouse/touch.
		if button.has_focus():
			return
		else:
			button.grab_focus()

	$MoveCursorSound.play()

func _create_options_buttons() -> void:
	music_style_button = _create_button("Music Style", "_toggle_music_style")
	main_buttons.push_back(music_style_button)
	back_button = _create_button("Back", "_back_button")
	main_buttons.push_back(back_button)

func _clear_buttons() -> void:
	for button in $"VBoxContainer/Buttons".get_children():
		button.queue_free()
	main_buttons = []

func _back_button() -> void:
	$SelectSound.play()
	_clear_buttons()
	_create_main_buttons()
	_show_main_buttons(new_game_button)

func _toggle_music_style() -> void:
	$SelectSound.play()
	print("toggle music style")

func _create_button(text: String, callback: String) -> Button:
	var button := Button.new()
	button.text = text
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.connect("button_down", self, callback)
	button.connect("focus_entered", self, "_on_focus_entered", [null])
	button.connect("mouse_entered", self, "_on_focus_entered", [button])
	return button

func _create_main_buttons() -> void:
	new_game_button = _create_button("New Game", "_new_game")
	main_buttons.push_back(new_game_button)
	# options_button = _create_button("Options", "_options")
	# main_buttons.push_back(options_button)
	exit_button = _create_button("Exit", "_exit")
	main_buttons.push_back(exit_button)
