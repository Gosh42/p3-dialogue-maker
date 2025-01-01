class_name Screen
extends Control

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var corner: TextureRect = %Main
@onready var arrow: TextureRect = %Arrow
@onready var daytime_sprite: Sprite2D = %DaytimeSprite

const CORNER_BLUE: Color = Color(0x4996feff)
const CORNER_BLUE_PORTABLE: Color = Color(0x67bbffff)
const CORNER_PINK: Color = Color(0xf898b3ff)
const CORNER_GREEN: Color = Color(0x79fe8cff)
const CORNER_GREEN_PORTABLE: Color = Color(0x2eb05aff)
var current_colour: Color

enum Daytimes {
	BEFORE_DAWN,
	EARLY_MORNING,
	MORNING,
	DAYTIME,
	LUNCHTIME,
	AFTERNOON,
	AFTER_SCHOOL,
	EVENING,
	LATE_NIGHT,
	DARK_HOUR,
	UNKNOWN
}


func _ready() -> void:
	current_colour = CORNER_BLUE

# =================== NAME AND DIALOGUE ====================== #

func set_name_text(text: String) -> void:
	name_label.text = text


func set_dialogue_text(text: String) -> void:
	dialogue_label.text = text

# =================== COLOUR SELECTION ====================== #

func choose_colour(index: int) -> void:
	match index:
		0: current_colour = CORNER_BLUE
		1: current_colour = CORNER_BLUE_PORTABLE
		2: current_colour = CORNER_PINK
		3: current_colour = CORNER_GREEN
		4: current_colour = CORNER_GREEN_PORTABLE
	
	change_corner_colour(current_colour)


func set_custom_colour(colour: Color) -> void:
	current_colour = Color(colour)
	change_corner_colour(current_colour)


func change_corner_colour(colour: Color) -> void:
	corner.modulate = colour


func set_daytime(index: int) -> void:
	var daytime: Daytimes = Daytimes.values()[index]
	
	daytime_sprite.frame = daytime
	
	if daytime == Daytimes.DARK_HOUR:
		change_corner_colour(CORNER_GREEN)
	else:
		change_corner_colour(current_colour)


func toggle_arrow(toggled_on: bool) -> void:
	arrow.visible = toggled_on
