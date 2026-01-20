extends Node

var is_paused: bool = false

var final_time = 0;

signal game_paused(paused: bool)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func pause_game():
	if is_paused:
		return
	
	is_paused = true
	get_tree().paused = true
	game_paused.emit(true)

func resume_game():
	if not is_paused:
		return
	
	is_paused = false
	get_tree().paused = false
	game_paused.emit(false)

func toggle_pause():
	if is_paused:
		resume_game()
	else:
		pause_game()
