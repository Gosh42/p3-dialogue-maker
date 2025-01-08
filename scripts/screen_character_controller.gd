class_name CharacterController
extends Node

@onready var char_texture: TextureRect = %Character


func set_sprite(image: Texture) -> void:
	char_texture.texture = image


func set_flip(flip: bool) -> void:
	char_texture.flip_h = flip


func set_pos(pos: float) -> void:
	char_texture.position.x = pos
