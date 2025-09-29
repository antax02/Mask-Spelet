extends Control

@onready var resume_button = $Panel/VBoxContainer/ResumeButton
@onready var restart_button = $Panel/VBoxContainer/RestartButton
@onready var menu_button = $Panel/VBoxContainer/MenuButton

const BUTTON_FONT_SIZE = 32
const BUTTON_CORNER_RADIUS = 8
const BUTTON_PADDING = Vector4(20, 5, 20, 5)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Start hidden
	visible = false
	
	# Connect to Global signal
	Global.game_paused.connect(_on_game_paused)
	
	# Connect button signals
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Apply styling
	var buttons = get_all_buttons()
	for button in buttons:
		apply_button_style(button)

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC key
		Global.toggle_pause()

func _on_game_paused(paused: bool):
	visible = paused

func get_all_buttons() -> Array[Button]:
	return [resume_button, restart_button, menu_button]

func apply_button_style(button: Button):
	var stylebox_normal = create_stylebox(Color(0, 0, 0, 0), 0)
	var stylebox_hover = create_stylebox(Color(1, 1, 1, 0.1), BUTTON_CORNER_RADIUS)
	var stylebox_pressed = create_stylebox(Color(1, 1, 1, 0.15), BUTTON_CORNER_RADIUS)
	
	button.add_theme_stylebox_override("normal", stylebox_normal)
	button.add_theme_stylebox_override("hover", stylebox_hover)
	button.add_theme_stylebox_override("pressed", stylebox_pressed)
	button.add_theme_stylebox_override("focus", stylebox_normal)
	
	button.add_theme_color_override("font_color", Color.WHITE)
	button.add_theme_color_override("font_hover_color", Color.WHITE)
	button.add_theme_color_override("font_pressed_color", Color.WHITE)
	button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER

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

func _on_resume_pressed():
	Global.resume_game()

func _on_restart_pressed():
	# Unpause and reset state
	Global.is_paused = false
	get_tree().paused = false
	
	# Get current scene and restart
	var current_scene = get_tree().current_scene.scene_file_path
	SceneTransition.change_scene(current_scene)

func _on_menu_pressed():
	# Unpause and reset state
	Global.is_paused = false
	get_tree().paused = false
	
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
