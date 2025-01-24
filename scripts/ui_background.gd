extends Node

var bg_ctrl: BackgroundController
const PATH = "res://images/backgrounds"

@onready var location_select: OptionButton = %LocationSelection
@onready var parent_vbox: VBoxContainer = %Background
@onready var container: GridContainer = %GridContainer

var location_names: PackedStringArray
var bg_names: PackedStringArray

# ====================== INITIAL SETUP ====================== #

func _ready() -> void:
	var screen: ScreenControlGetter = %Screen
	bg_ctrl = screen.get_background_controller()
	
	var dir: DirAccess = DirAccess.open(PATH)
	location_names = dir.get_directories()
	
	for location in location_names:
		location_select.add_item(location.capitalize())
	
	parent_vbox.resized.connect(_on_resized)
	
	var selection_index: int = randi() % location_select.item_count
	location_select.select(selection_index)
	_on_location_selected(selection_index)

# ====================== BACKGROUND SELECTION ====================== #

func _on_location_selected(index: int) -> void:
	bg_names.clear()
	for child: Node in container.get_children():
		child.queue_free()
	
	var location: String = location_names[index]
	var dir: DirAccess = DirAccess.open(PATH + "/" + location)
	
	for bg_name: String in dir.get_files():
		if not (bg_name.ends_with(".import")):
			bg_names.append(bg_name)
			
			# Setting up a new button for each background
			var btn: Button = Button.new()
			btn.text = bg_name.get_basename().capitalize()
			btn.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
			btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			btn.custom_minimum_size = Vector2i(200, 200)
			
			var texture: Texture = load(PATH + "/" + location + "/" + bg_name)
			btn.icon = texture
			btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			btn.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
			btn.expand_icon = true
			
			btn.set("theme_override_colors/icon_hover_color", Color.from_hsv(1, 0, 1.2))
			btn.set("theme_override_colors/icon_pressed_color", Color.from_hsv(1, 0, 0.8))
			
			btn.pressed.connect(_on_btn_pressed.bind(texture))
			
			container.add_child(btn)


func _on_btn_pressed(texture: Texture) -> void:
	bg_ctrl.set_bg(texture)

# ====================== COLUMN COUNT ADJUSTMENT ====================== #

func _on_resized() -> void:
	var col: int = container.columns
	var h: int = container.get_theme_constant("h_separation")
	col = (parent_vbox.size.x - (col + 2.5) * h) / 200
	container.columns = max(1, col)
