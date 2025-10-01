extends Control


@onready var master_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
@onready var music_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $Panel/MarginContainer/VBoxContainer/SFXVolumeContainer/SFXVolumeSlider

@onready var fullscreen_check_box: CheckBox = $Panel/MarginContainer/VBoxContainer/FullscreenCheckBox
@onready var screenshake_check_box: CheckBox = $Panel/MarginContainer/VBoxContainer/screenshakeCheckBox

@onready var back_button: Button = $Panel/MarginContainer/VBoxContainer/Back

func _ready():
	master_volume_slider.value = SettingsManager.master_volume
	music_volume_slider.value = SettingsManager.music_volume
	sfx_volume_slider.value = SettingsManager.sfx_volume
	fullscreen_check_box.button_pressed = SettingsManager.fullscreen
	screenshake_check_box.button_pressed = SettingsManager.screen_shake
	
	master_volume_slider.value_changed.connect(_on_master_changed)
	music_volume_slider.value_changed.connect(_on_music_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_changed)
	fullscreen_check_box.toggled.connect(_on_fullscreen_toggled)
	screenshake_check_box.toggled.connect(_on_screenshake_toggled)
	
	back_button.pressed.connect(_on_back_pressed)
	ButtonStyler.apply_button_style(back_button)

func _on_master_changed(value):
	SettingsManager.master_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_music_changed(value):
	SettingsManager.music_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_sfx_changed(value):
	SettingsManager.sfx_volume = value
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_fullscreen_toggled(pressed):
	SettingsManager.fullscreen = pressed
	SettingsManager.apply_settings()
	SettingsManager.save_settings()

func _on_screenshake_toggled(pressed):
	SettingsManager.screen_shake = pressed
	SettingsManager.save_settings()
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")

func _on_back_pressed():
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
