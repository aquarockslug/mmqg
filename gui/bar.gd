tool
extends Control

# Do not set these values below 0.035. Otherwise sound might occasionally not play at all.
# Related to https://github.com/godotengine/godot/issues/37148
const FILL_DELAY: float = 0.05
const FILL_DELAY_NON_PAUSING: float = 0.035

export(String) var bar_name := ""
export(Color) var color := Color("e7e794") setget set_bar_color
export(bool) var horizontal := false setget set_bar_orientation
export(bool) var fill_with_sound := true

var _is_updating := false

onready var _overlay = $"TextureRect/ColorRect"
onready var _overlay_h = $"TextureRectHorizontal/ColorRect"

signal gradual_update_complete()
signal _bar_update_complete()

func _ready() -> void:
    pass
    # if Engine.editor_hint:
    #     visible = false

func on_restarted() -> void:
        visible = true
        update_instant(Constants.HIT_POINTS_MAX)

func on_hit_points_changed(hit_points: int) -> void:
    if hit_points < _get_current_hp_bar():
        update_instant(hit_points)
    elif hit_points > _get_current_hp_bar():
        update_gradual(hit_points)

func on_weapon_changed(weapon_energy: int, new_color: Color) -> void:
    if new_color == Color.transparent:
        visible = false
    else:
        set_bar_color(new_color)
        update_instant(weapon_energy)
        visible = true

func update_instant(hit_points: int) -> void:
    _set_current_hp_bar(hit_points)

func update_gradual(hit_points) -> void:
    if not Global.bar_fill_pause:
        _update_bar(hit_points)
        yield(self, "_bar_update_complete")
        emit_signal("gradual_update_complete")
        return

    if _is_updating:
        return
    
    Global.can_toggle_pause = false
    _is_updating = true
    var was_paused: bool = get_tree().paused
    get_tree().paused = true
    _update_bar(hit_points)
    yield(self, "_bar_update_complete")
    get_tree().paused = was_paused
    _is_updating = false
    emit_signal("gradual_update_complete")
    Global.can_toggle_pause = true

func set_bar_color(value: Color) -> void:
    if has_node("TextureRect/ColorOverlay") and has_node("TextureRectHorizontal/ColorOverlay"):
        $"TextureRect/ColorOverlay".modulate = value
        $"TextureRectHorizontal/ColorOverlay".modulate = value
        color = value

func set_bar_orientation(is_horizontal: bool) -> void:
    if has_node("TextureRectHorizontal") and has_node("TextureRect"):
        $"TextureRect".visible = !is_horizontal
        $"TextureRectHorizontal".visible = is_horizontal
        horizontal = is_horizontal

func _set_current_hp_bar(hit_points: int) -> void:
    var offset := clamp(2 * (Constants.HIT_POINTS_MAX - hit_points), 0, 2 * Constants.HIT_POINTS_MAX)
    if horizontal:
        _overlay_h["rect_size"].x = offset
        _overlay_h["rect_position"].x = 2 * Constants.HIT_POINTS_MAX - offset
    else:
        _overlay["rect_size"].y = offset

func _get_current_hp_bar() -> int:
    if horizontal:
        return int(round(Constants.HIT_POINTS_MAX - _overlay_h["rect_size"].x / 2))
    else:
        return int(round(Constants.HIT_POINTS_MAX - _overlay["rect_size"].y / 2))

func _update_bar(hit_points) -> void:
    var fill_delay: float = FILL_DELAY if Global.bar_fill_pause else FILL_DELAY_NON_PAUSING
    if fill_with_sound:
        # stop() and stream_paused is part of a workaround to avoid infinite gage sound.
        # See https://github.com/godotengine/godot/issues/37148
        $FillSound.stop()
        $FillSound.stream_paused = false
        $FillSound.play()
    while round(clamp(hit_points, 0, Constants.HIT_POINTS_MAX)) != round(_get_current_hp_bar()):
        yield(get_tree().create_timer(fill_delay), "timeout")
        _set_current_hp_bar(_get_current_hp_bar() + sign(hit_points - _get_current_hp_bar()))

    $FillSound.stream_paused = true  # Part of above workaround. Should just be stop() here.
    $FillSound.call_deferred("stop")  # Ensure that audio is properly stopped as part of workaround.
    # Otherwise audio will be resumed in infinite loop when exiting the pause menu or after
    # a camera screen transition due to get_tree().paused = false.

    emit_signal("_bar_update_complete")
