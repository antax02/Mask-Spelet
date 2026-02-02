extends Node2D

@onready var back_button: Button = $CanvasLayer/ColorRect/VBoxContainer/Button
@onready var time = $CanvasLayer/ColorRect/VBoxContainer/Label2

func _ready() -> void:
	time.text = format_time(PauseManager.final_time)
	back_button.pressed.connect(_on_button_pressed)
	ButtonStyler.apply_button_style(back_button)

func _on_button_pressed() -> void:
	SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")

func format_time(time: float) -> String:
	var total_seconds = int(time)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	var milliseconds = int((time - int(time)) * 1000)
	
	if hours > 0:
		return "%02d:%02d:%02d.%03d" % [hours, minutes, seconds, milliseconds]
	else:
		return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
