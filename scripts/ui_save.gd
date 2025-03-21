extends Node

@onready var viewport_texture: TextureRect = %ViewportTexture
@onready var save_dialog: FileDialog = %SaveDialog


func _ready() -> void:
	save_dialog.current_path = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES) + "/"


func _on_save_button_down() -> void:
	save_dialog.popup()


func _on_save_confirmed(path: String) -> void:
	await RenderingServer.frame_post_draw
	
	var image: Image = viewport_texture.texture.get_image()
	
	match path.get_extension():
		"png": image.save_png(path)
		"jpg": image.save_jpg(path)
		"jpeg": image.save_jpg(path)
		"webp": image.save_webp(path)
