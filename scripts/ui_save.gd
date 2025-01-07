extends Node

@onready var viewport_texture: TextureRect = %ViewportTexture


func _on_save_button_down() -> void:
	await RenderingServer.frame_post_draw
	
	var image: Image = viewport_texture.texture.get_image()
	image.save_png("res://images/yeah.png")
