extends "on_ground.gd"

const STILL_FRAME_COUNT: int = 4

export(Vector2) var buster_position := Vector2(21, 0)

var _frame_count: int

func _enter() -> void:
    animation_player.play("idle")
    mega_buster.position = buster_position
    _frame_count = -1

func _handle_command(command: String) -> void:
    ._handle_command(command)
    
    if command == "shoot":
        animation_player.stop()
        animation_player.play(
            "idle_shoot_alt" if weapons.current_state.use_alt_anim else "idle_shoot")
        shoot()

    if command.begins_with("weapon_"):
        weapons.change_weapon(command)

func _update(delta: float) -> void:
    _frame_count += 1
    if _frame_count > STILL_FRAME_COUNT:
        owner.is_still = true
    
    # To check if on floor
    owner.move_and_slide(Vector2.DOWN * owner.gravity, Constants.FLOOR_NORMAL)
    
    if not owner.is_on_floor():
        emit_signal("finished", "jump")
    elif get_input_direction().x != 0:
        emit_signal("finished", "move")

    if owner.charge_level > 0 and not inputs.is_action_pressed(InputHandler.Action.SHOOT):
        _handle_command("shoot")

func _on_animation_finished(anim_name: String) -> void:
    if anim_name.begins_with("idle_shoot"):
        animation_player.play("idle")
