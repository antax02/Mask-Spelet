extends Node

const BUTTON_FONT_SIZE = 32
const BUTTON_CORNER_RADIUS = 8
const BUTTON_PADDING = Vector4(20, 5, 20, 5)

const HOVER_OFFSET = 10
const HOVER_DURATION = 0.15
const FADE_DURATION = 0.3

const COLOR_NORMAL = Color(0, 0, 0, 0)
const COLOR_HOVER = Color(1, 1, 1, 0.1)
const COLOR_PRESSED = Color(1, 1, 1, 0.15)
const FONT_COLOR = Color.WHITE

func create_stylebox(bg_color: Color, corner_radius: int) -> StyleBoxFlat:
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


func apply_button_style(button: Button, alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> void:
	var stylebox_normal = create_stylebox(COLOR_NORMAL, 0)
	var stylebox_hover = create_stylebox(COLOR_HOVER, BUTTON_CORNER_RADIUS)
	var stylebox_pressed = create_stylebox(COLOR_PRESSED, BUTTON_CORNER_RADIUS)
	
	button.add_theme_stylebox_override("normal", stylebox_normal)
	button.add_theme_stylebox_override("hover", stylebox_hover)
	button.add_theme_stylebox_override("pressed", stylebox_pressed)
	button.add_theme_stylebox_override("focus", stylebox_normal)
	
	button.add_theme_color_override("font_color", FONT_COLOR)
	button.add_theme_color_override("font_hover_color", FONT_COLOR)
	button.add_theme_color_override("font_pressed_color", FONT_COLOR)
	
	button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	button.alignment = alignment


func apply_style_to_buttons(buttons: Array[Button], alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER) -> void:
	for button in buttons:
		apply_button_style(button, alignment)
