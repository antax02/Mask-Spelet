extends Control

@onready var play_button = $VBoxContainer/MarginContainer/VBoxContainer/PlayButton
@onready var options_button = $VBoxContainer/MarginContainer/VBoxContainer/OptionsButton
@onready var credits_button = $VBoxContainer/MarginContainer/VBoxContainer/CreditsButton
@onready var quit_button = $VBoxContainer/MarginContainer/VBoxContainer/QuitButton
@onready var title_label = $VBoxContainer/TitleContainer/TitleLabel

var button_original_positions = {}


func _ready():
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	var buttons = get_all_buttons()
	ButtonStyler.apply_style_to_buttons(buttons, HORIZONTAL_ALIGNMENT_LEFT)
	
	await get_tree().process_frame
	_setup_hover_animations(buttons)


func get_all_buttons() -> Array[Button]:
	return [play_button, options_button, credits_button, quit_button]


func _setup_hover_animations(buttons: Array[Button]) -> void:
	for button in buttons:
		button_original_positions[button] = button.position.x
		button.mouse_entered.connect(_on_button_hover.bind(button))
		button.mouse_exited.connect(_on_button_unhover.bind(button))


func _on_button_hover(button: Button):
	if button_original_positions.has(button):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(button, "position:x", 
			button_original_positions[button] + ButtonStyler.HOVER_OFFSET, 
			ButtonStyler.HOVER_DURATION)


func _on_button_unhover(button: Button):
	if button_original_positions.has(button):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(button, "position:x", 
			button_original_positions[button], 
			ButtonStyler.HOVER_DURATION)


func _on_play_pressed():
	SceneTransition.change_scene("res://scenes/levels/main_2.tscn")


func _on_options_pressed():
	SceneTransition.change_scene("res://scenes/ui/settings_menu.tscn")


func _on_credits_pressed():
	SceneTransition.change_scene("res://scenes/ui/credits.tscn")


func _on_quit_pressed():
	get_tree().quit()
