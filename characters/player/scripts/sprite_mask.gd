extends Sprite

# Implemented as separate script to be able to process this SpriteMask node
# while player itself is not processed when in pause mode.
# This is required during camera transitions in order to correctly update
# the mask sprites.

var _mask_textures: Dictionary = {

}

onready var _sprite: Sprite = $"../Sprite"

func _ready() -> void:
	if Global.lighting_vfx:
		modulate = Color(1.1, 1.1, 1.1, 1)

func _physics_process(_delta: float) -> void:
	position = _sprite.position
	offset = _sprite.offset
	flip_h = _sprite.flip_h
	flip_v = _sprite.flip_v
	hframes = _sprite.hframes
	vframes = _sprite.vframes
	frame = _sprite.frame
	# texture = _mask_textures[_sprite.texture.resource_path]
