extends Node

const SCREENSHOT_PATH := "user://screenshots/"
const SCREENSHOT_NAME := "MMGScrnShot"
const DATETIME_FORMAT := "%02d"

var main_scene: Node
var current_stage: Stage setget , get_current_stage
var player: Player setget , get_player
var players: Dictionary setget , get_players
var players_alive_count: int setget , get_players_alive_count
var can_toggle_pause := true
var in_pause_menu := false
var base_size: Vector2 setget , get_base_size
var rng := RandomNumberGenerator.new()
var touch_buttons: Array

# Options
var wide_screen := true setget set_wide_screen
var bar_fill_pause := false
var lighting_vfx := true  # Requires World Environment with glow effect.
var use_touch_controls: bool setget , _get_use_touch_controls

signal internal_res_changed()

func _ready() -> void:
    rng.randomize()

    # Last child of root is always main scene
    var root := get_tree().get_root()
    main_scene = root.get_child(root.get_child_count() - 1)

    # Hide mouse
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func get_current_stage() -> Stage:
    if main_scene is Stage:
        return main_scene as Stage
    elif "current_scene" in main_scene and main_scene.current_scene is Stage:
        return main_scene.current_scene as Stage
    else:
        printerr("Could not get current stage because currently no stage is loaded.")
        return null

func get_player() -> Player:
    return get_current_stage().player

func get_players() -> Dictionary:
    return get_current_stage().players

func get_players_alive_count() -> int:
    var count: int = 0
    for p in get_current_stage().players.values():
        if not p.is_dead:
            count += 1

    return count

func take_screenshot() -> void:
    var dir: Directory = Directory.new()
    if not dir.dir_exists(SCREENSHOT_PATH):
        dir.make_dir(SCREENSHOT_PATH)

    var datetime := OS.get_datetime()
    datetime["year"] = (DATETIME_FORMAT % datetime["year"]).substr(2, 2)
    datetime["month"] = DATETIME_FORMAT % datetime["month"]
    datetime["day"] = DATETIME_FORMAT % datetime["day"]
    datetime["hour"] = DATETIME_FORMAT % datetime["hour"]
    datetime["minute"] = DATETIME_FORMAT % datetime["minute"]
    datetime["second"] = DATETIME_FORMAT % datetime["second"]
    var screenshot_filename := str(SCREENSHOT_PATH, SCREENSHOT_NAME, "_",
            datetime["month"], datetime["day"], datetime["year"], "_",
            datetime["hour"], datetime["minute"], datetime["second"], ".png")

    if dir.file_exists(screenshot_filename):
        printerr("Could not save screenshot. File already exists.")
        return

    var image := get_viewport().get_texture().get_data()
    image.flip_y()
    image.save_png(screenshot_filename)

func is_action_pressed(action: String) -> bool:
    # Temporary workaround until the following engine issue will be fixed.
    # https://github.com/godotengine/godot/issues/45628

    var is_pressed := false
    for event in InputMap.get_action_list(action):
        if event is InputEventKey:
            is_pressed = Input.is_key_pressed(event.scancode)
        elif event is InputEventJoypadButton:
            is_pressed = Input.is_joy_button_pressed(event.device, event.button_index)
        elif event is InputEventMouseButton:
            is_pressed = Input.is_mouse_button_pressed(event.button_index)
        elif event is InputEventJoypadMotion:
            is_pressed = true if Input.get_action_strength(action) > 0 else false
        # Add more elif to treat the type accordingly.
        else:
            continue

        if is_pressed:
            break

    for touch_button in touch_buttons:
        if is_pressed:
            break
        is_pressed = touch_button.action == action and touch_button.is_pressed()

    return is_pressed

func get_action_strength(action: String) -> float:
    # Temporary workaround until the following engine issue will be fixed.
    # https://github.com/godotengine/godot/issues/45628
    
    var action_strength := Input.get_action_strength(action)
    if action_strength == 0:
        action_strength = 1 if is_action_pressed(action) else 0
    
    return action_strength

func get_base_size() -> Vector2:
    if wide_screen:
        return Vector2(Constants.WIDTH_WIDE, Constants.HEIGHT_WIDE)
    else:
        return Vector2(Constants.WIDTH, Constants.HEIGHT)

func get_walk_speed() -> float:
    if wide_screen:
        return Constants.WALK_SPEED_WIDE
    else:
        return Constants.WALK_SPEED

func get_projectile_speed() -> float:
    if wide_screen:
        return Constants.PROJECTILE_SPEED_WIDE
    else:
        return Constants.PROJECTILE_SPEED

func set_wide_screen(value: bool) -> void:
    wide_screen = value
    emit_signal("internal_res_changed")

func _get_use_touch_controls() -> bool:
    return ProjectSettings.get_setting("custom/gui/touch_controls")
