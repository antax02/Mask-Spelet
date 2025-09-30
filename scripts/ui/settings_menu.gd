extends Control

@onready var back_button: Button = $Panel/MarginContainer/VBoxContainer/Back

const HOVER_OFFSET = 10
const HOVER_DURATION = 0.15
const FADE_DURATION = 0.3

const BUTTON_FONT_SIZE = 32
const BUTTON_CORNER_RADIUS = 8
const BUTTON_PADDING = Vector4(20, 5, 20, 5)


func _ready() -> void:
	var stylebox_normal = _create_stylebox(Color(0, 0, 0, 0), 0)
	var stylebox_hover = _create_stylebox(Color(1, 1, 1, 0.1), BUTTON_CORNER_RADIUS)
	var stylebox_pressed = _create_stylebox(Color(1, 1, 1, 0.15), BUTTON_CORNER_RADIUS)
	
	back_button.add_theme_stylebox_override("normal", stylebox_normal)
	back_button.add_theme_stylebox_override("hover", stylebox_hover)
	back_button.add_theme_stylebox_override("pressed", stylebox_pressed)
	back_button.add_theme_stylebox_override("focus", stylebox_normal)
	
	back_button.add_theme_color_override("font_color", Color.WHITE)
	back_button.add_theme_color_override("font_hover_color", Color.WHITE)
	back_button.add_theme_color_override("font_pressed_color", Color.WHITE)
	back_button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	back_button.alignment = HORIZONTAL_ALIGNMENT_LEFT


func _create_stylebox(bg_color: Color, corner_radius: int) -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = bg_color
	stylebox.border_width_left = 0
	stylebox.border_width_top = 0
	stylebox.border_width_right = 0
	stylebox.border_width_bottom = 0
	stylebox.corner_radius_top_left = corner_radius
	stylebox.corner_radius_top_right = corner_radius
	stylebox.corner_radius_bottom_left = corner_radius
	stylebox.corner_radius_bottom_right = corner_radius
	stylebox.content_margin_left = BUTTON_PADDING.x
	stylebox.content_margin_top = BUTTON_PADDING.y
	stylebox.content_margin_right = BUTTON_PADDING.z
	stylebox.content_margin_bottom = BUTTON_PADDING.w
	return stylebox
