extends "common.gd"

const CLIMB_SPEED: float = 78.0

var direction: Vector2
var _is_move_anim = false
var last_shooting_direction: Vector2

onready var collision_shape: CollisionShape2D = get_node("../../CollisionShape2D")

func _enter() -> void:
    last_shooting_direction = owner.get_facing_direction()
    animation_player.play("climb_idle")
    owner.is_climbing = true

func _exit() -> void:
    _is_move_anim = false
    owner.is_climbing = false
    update_sprite_direction(direction if direction.x != 0 else last_shooting_direction)

func _handle_command(command: String) -> void:
    if command == "shoot":
        emit_signal("finished", "climb_shoot")
    if command == "drop_down":
        emit_signal("finished", "jump")
    if command.begins_with("weapon_"):
        weapons.change_weapon(command)

func _update(delta: float) -> void:
    direction = get_input_direction()
    if direction.y != 0:
        if owner.ladder.is_exiting_ladder(owner):
            # collision_shape.shape.extents.y = 6
            animation_player.play("climb_exit")
        elif not _is_move_anim:
            _is_move_anim = true
            # collision_shape.shape.extents.y = 12
            animation_player.play("climb_move")
        
        # Exit when touching the floor while climbing.
        if (direction.y > 0
                and owner.test_move(owner.transform, Vector2(0, direction.y) * delta)):
            emit_signal("finished", "idle")
        else:
            owner.move_and_slide(Vector2(0, direction.y * CLIMB_SPEED))
    else:
        _is_move_anim = false
        if owner.ladder.is_exiting_ladder(owner):
            # collision_shape.shape.extents.y = 6
            animation_player.play("climb_exit")
        else:
            # collision_shape.shape.extents.y = 12
            animation_player.play("climb_idle")

    if owner.charge_level > 0 and not inputs.is_action_pressed(InputHandler.Action.SHOOT):
        _handle_command("shoot")
