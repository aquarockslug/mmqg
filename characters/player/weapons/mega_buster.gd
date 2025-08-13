extends KinematicBody2D

export(int) var damage := 1

var direction: Vector2
var consumed := false
    
func _ready() -> void:
    if Global.lighting_vfx:
        modulate = Color(2, 1, 1, 1)

    if not $PreciseVisibilityNotifier2D.is_on_screen():
        queue_free()
    $ShootSFX.play()

    if direction.x < 0:
        $Sprite.flip_h = true
        if has_node("AnimatedSprite"):  # Charge level 2
            $AnimatedSprite.flip_h = true

    if has_node("AnimatedSprite"):  # Charge level 2
        $MuzzleFlashAnimatedSprite.set_as_toplevel(true)
        $MuzzleFlashAnimatedSprite.global_position = global_position
        $MuzzleFlashAnimatedSprite.play("muzzle_flash")
        $AnimatedSprite.play("default")

func _physics_process(delta: float) -> void:
    move_and_collide(direction.normalized() * Global.get_projectile_speed() * delta)

func reflect() -> void:
    $ReflectSFX.play()
    direction = Vector2(-direction.x, -1)
    $Sprite.flip_h = !$Sprite.flip_h

    if has_node("AnimatedSprite"):  # Charge level 2
        $AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
        $AnimatedSprite.play("reflected")
        $CollisionShape2D.shape.extents.y = 5
        $CollisionShape2D.position.x = 0

func on_camera_exited() -> void:
    queue_free()

func queue_free() -> void:
    consumed = true
    if $ShootSFX.playing:
        visible = false
        $CollisionShape2D.set_deferred("disabled", true)
        yield($ShootSFX, "finished")
    .queue_free()
