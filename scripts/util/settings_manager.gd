extends Node

const SETTINGS_FILE = "user://settings.cfg"

var master_volume = 50.0
var music_volume = 100.0
var sfx_volume = 100.0

var fullscreen = false
var screen_shake = true

func _ready():
	load_settings()
	apply_settings()

func apply_settings():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume / 100.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume / 100.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume / 100.0))
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	
	config.set_value("game", "fullscreen", fullscreen)
	config.set_value("game", "screen_shake", screen_shake)
	
	config.save(SETTINGS_FILE)

func load_settings():
	var config = ConfigFile.new()
	if config.load(SETTINGS_FILE) != OK:
		return
	
	master_volume = config.get_value("audio", "master_volume", master_volume)
	music_volume = config.get_value("audio", "music_volume", music_volume)
	sfx_volume = config.get_value("audio", "sfx_volume", sfx_volume)
	
	fullscreen = config.get_value("game", "fullscreen", fullscreen)
	screen_shake = config.get_value("game", "screen_shake", screen_shake)
