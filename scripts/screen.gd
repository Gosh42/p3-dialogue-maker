class_name Screen
extends Control

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var arrow: TextureRect = %Arrow

@onready var corner: TextureRect = %Main

@onready var month_tens: TextureRect = %MonthTens
@onready var month_ones: TextureRect = %MonthOnes
@onready var slash: TextureRect = %Slash
@onready var day_tens: TextureRect = %DayTens
@onready var day_ones: TextureRect = %DayOnes
@onready var dot: TextureRect = %Dot
@onready var weekday: TextureRect = %Weekday

@onready var daytime_sprite: Sprite2D = %DaytimeSprite

@onready var next_tens: TextureRect = %NextTens
@onready var next_ones: TextureRect = %NextOnes
@onready var moon_phase_controller: AnimationPlayer = %MoonPhase

const CORNER_BLUE: Color = Color(0x4996feff)
const CORNER_BLUE_PORTABLE: Color = Color(0x67bbffff)
const CORNER_PINK: Color = Color(0xf898b3ff)
const CORNER_GREEN: Color = Color(0x79fe8cff)
const CORNER_GREEN_PORTABLE: Color = Color(0x2eb05aff)
var current_colour: Color

enum Daytimes {
	BEFORE_DAWN,	EARLY_MORNING,	MORNING,
	DAYTIME,		LUNCHTIME,		AFTERNOON,
	AFTER_SCHOOL,	EVENING,		LATE_NIGHT,
	DARK_HOUR,		UNKNOWN
}

var digits_ones: Array[Texture2D]
var digits_tens: Array[Texture2D]
var digits_month_ones: Array[Texture2D]
var question_mark_digit: Texture2D
var weekdays: Array[Texture2D]
var current_month: int
var current_day: int


func _ready() -> void:
	current_colour = CORNER_BLUE
	moon_phase_controller.play("moon_cycle")
	
	for i in range(10):
		digits_ones.append(load("res://images/ui/date_numbers/%d.png" % i))
	
	digits_tens = digits_ones.duplicate()
	digits_tens[0] = preload("res://images/ui/date_numbers/blank_digit.png")
	
	digits_month_ones = digits_ones.duplicate()
	digits_month_ones[1] = \
		preload("res://images/ui/date_numbers/1_but_for_january_or_november's_second_digit.png")
	
	question_mark_digit = preload("res://images/ui/date_numbers/question_mark.png")
	
	for s: String in ["M", "Tu", "W", "Th", "F", "Sa", "Su", "question_mark_weekday"]:
		weekdays.append(load("res://images/ui/date_numbers/%s.png" % s))

# =================== NAME AND DIALOGUE ====================== #

func set_name_text(text: String) -> void:
	name_label.text = text


func set_dialogue_text(text: String) -> void:
	dialogue_label.text = text


func toggle_arrow(toggled_on: bool) -> void:
	arrow.visible = toggled_on

# =================== TIME SELECTION ====================== #

func set_daytime(index: int) -> void:
	var daytime: Daytimes = Daytimes.values()[index]
	
	daytime_sprite.frame = daytime
	
	if daytime == Daytimes.DARK_HOUR:
		change_corner_colour(CORNER_GREEN)
	else:
		change_corner_colour(current_colour)


func set_month(month: int) -> void:
	current_month = month
	
	var digit1: int = month / 10
	var digit2: int = month % 10
	
	month_tens.texture = digits_tens[digit1]
	month_ones.texture = digits_month_ones[digit2]


func set_day(day: int) -> void:
	current_day = day
	
	var digit1: int = day / 10
	var digit2: int = day % 10
	
	day_tens.texture = digits_tens[digit1]
	day_ones.texture = digits_ones[digit2]


func set_weekday(index: int) -> void:
	weekday.texture = weekdays[index]
	
	if index == 7: # question mark
		month_tens.hide()
		day_tens.hide()
		
		month_ones.texture = question_mark_digit
		day_ones.texture = question_mark_digit
		change_corner_colour(current_colour)
	elif not month_tens.visible:
		month_tens.show()
		day_tens.show()
		
		set_month(current_month)
		set_day(current_day)
		change_corner_colour(current_colour)


func set_moon_phase(days_until_full: int) -> void:
	var digit1: int = days_until_full / 10
	var digit2: int = days_until_full % 10
	
	# instead of just using an empty texture like before, i manually hide
	# the number, because this will make the offset between "Next:" and 
	# the digit one pixel less, which ends up more accurate to the game
	next_tens.visible = digit1 > 0
	next_tens.texture = digits_ones[digit1]
	next_ones.texture = digits_ones[digit2]
	
	moon_phase_controller.seek(30 - days_until_full, true)

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
	
	var digit_colour: Color
	var weekday_colour: Color
	
	if month_tens.visible:
		digit_colour = Color.from_hsv(colour.h, colour.s, colour.v * 0.2)
		weekday_colour = Color.from_hsv(colour.h, colour.s * 0.333333, colour.v * 0.333333)
	else:
		digit_colour = Color.from_hsv(colour.h, colour.s * 0.666667, colour.v * 0.333333)
		weekday_colour = digit_colour
		
	for digit: TextureRect in [month_tens, month_ones, day_tens, day_ones]:
		digit.modulate = digit_colour
		
	slash.modulate = Color.from_hsv(colour.h, colour.s * 0.666667, colour.v * 0.25)
	dot.modulate = Color.from_hsv(colour.h, colour.s * 0.7, colour.v * 0.333333)
	weekday.modulate = weekday_colour
	
	next_tens.modulate = colour
	next_ones.modulate = colour
