class_name Screen
extends Control

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var corner: TextureRect = %Main
@onready var daytime_sprite: Sprite2D = %DaytimeSprite

const CORNER_BLUE: Color = Color(0x4996feff)
const CORNER_GREEN: Color = Color(0x79fe8cff)

enum Daytimes {
	EARLY_MORNING,	MORNING,
	DAYTIME,		LUNCHTIME,
	AFTERNOON,		AFTER_SCHOOL,
	EVENING,		LATE_NIGHT,
	DARK_HOUR
}


func set_name_text(str: String) -> void:
	name_label.text = str


func set_dialogue_text(str: String) -> void:
	dialogue_label.text = str


func set_daytime(index: int) -> void:
	var daytime: Daytimes = Daytimes.values()[index]
	
	daytime_sprite.frame = daytime
	
	if daytime == Daytimes.DARK_HOUR:
		corner.modulate = CORNER_GREEN
	else:
		corner.modulate = CORNER_BLUE
