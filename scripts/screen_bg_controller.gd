class_name BackgroundController
extends Node

@onready var background: TextureRect = %Background


func set_bg(image: Texture) -> void:
	background.texture = image
