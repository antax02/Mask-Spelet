extends Control

@onready var play_button = $VBoxContainer/MarginContainer/VBoxContainer/PlayButton
@onready var options_button = $VBoxContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var credits_button = $VBoxContainer/MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $VBoxContainer/MarginContainer/VBoxContainer/QuitButton
@onready var title_label = $VBoxContainer/TitleContainer/TitleLabel

var button_original_positions = {}

const HOVER_OFFSET = 10
const HOVER_DURATION = 0.15
const FADE_DURATION = 0.3

const BUTTON_FONT_SIZE = 32
const BUTTON_CORNER_RADIUS = 8
const BUTTON_PADDING = Vector4(20, 5, 20, 5)


func _ready():
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	var buttons = _get_all_buttons()
	for button in buttons:
		_apply_button_style(button)
	
	await get_tree().process_frame
	for button in buttons:
		button_original_positions[button] = button.position.x
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))


func _get_all_buttons() -> Array[Button]:
	return [play_button, options_button, credits_button, quit_button]


func _apply_button_style(button: Button):
	var stylebox_normal = _create_stylebox(Color(0, 0, 0, 0), 0)
	var stylebox_hover = _create_stylebox(Color(1, 1, 1, 0.1), BUTTON_CORNER_RADIUS)
	var stylebox_pressed = _create_stylebox(Color(1, 1, 1, 0.15), BUTTON_CORNER_RADIUS)
	
	button.add_theme_stylebox_override("normal", stylebox_normal)
	button.add_theme_stylebox_override("hover", stylebox_hover)
	button.add_theme_stylebox_override("pressed", stylebox_pressed)
	button.add_theme_stylebox_override("focus", stylebox_normal)
	
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT


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


func _on_button_hover(button: Button):
	if button_original_positions.has(button):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(button, "position:x", button_original_positions[button] + HOVER_OFFSET, HOVER_DURATION)


func _on_button_unhover(button: Button):
	if button_original_positions.has(button):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(button, "position:x", button_original_positions[button], HOVER_DURATION)


func _on_play_pressed():
	SceneTransition.change_scene("res://scenes/levels/test_level.tscn")


func _on_options_pressed():
	SceneTransition.change_scene("res://scenes/ui/options_menu.tscn")


func _on_credits_pressed():
	SceneTransition.change_scene("res://scenes/ui/credits.tscn")


func _on_quit_pressed():
	get_tree().quit()
