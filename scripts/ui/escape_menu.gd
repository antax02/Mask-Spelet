extends Control

@onready var resume_button = $Panel/VBoxContainer/ResumeButton
@onready var restart_button = $Panel/VBoxContainer/RestartButton
@onready var menu_button = $Panel/VBoxContainer/MenuButton


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	
	Global.game_paused.connect(_on_game_paused)
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	var buttons = get_all_buttons()
	ButtonStyler.apply_style_to_buttons(buttons, HORIZONTAL_ALIGNMENT_CENTER)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Global.toggle_pause()


func _on_game_paused(paused: bool):
	visible = paused


func get_all_buttons() -> Array[Button]:
	return [resume_button, restart_button, menu_button]


func _on_resume_pressed():
	Global.resume_game()


func _on_restart_pressed():
	Global.is_paused = false
	get_tree().paused = false
	
	var current_scene = get_tree().current_scene.scene_file_path
	SceneTransition.change_scene(current_scene)


func _on_menu_pressed():
	Global.is_paused = false
	get_tree().paused = false
	
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
