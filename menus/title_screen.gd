extends Control

var main_buttons: Array
var new_game_button: Button
var options_button: Button
var exit_button: Button

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
        _show_main_buttons()
    
func _show_main_buttons() -> void:
    for button in main_buttons:
        $"VBoxContainer/Buttons".add_child(button)
    new_game_button.grab_focus()

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

func _create_main_buttons() -> void:
    new_game_button = _create_button("New Game", "_new_game")
    main_buttons.push_back(new_game_button)
    options_button = _create_button("Options", "_options")
    main_buttons.push_back(options_button)
    exit_button = _create_button("Exit", "_exit")
    main_buttons.push_back(exit_button)

func _create_button(text: String, callback: String) -> Button:
    var button := Button.new()
    button.text = text
    button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
    button.mouse_filter = Control.MOUSE_FILTER_STOP
    button.connect("button_down", self, callback)
    button.connect("focus_entered", self, "_on_focus_entered", [null])
    button.connect("mouse_entered", self, "_on_focus_entered", [button])
    return button
