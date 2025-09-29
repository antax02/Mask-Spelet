extends Control

@onready var timer_label = $TimerLabel  # Label node to display the timer
@onready var final_time_label = $FinalTimeLabel  # Label to show final time (initially hidden)

var start_time: float = 0.0
var is_running: bool = false
var final_time: float = 0.0

func _ready():
	# Start the timer immediately when the scene loads
	start_timer()
	
	# Hide final time label initially
	if final_time_label:
		final_time_label.visible = false
	
	# Connect to the finish line signal
	# Make sure your finish line area is named "FinishLine" or adjust the path
	var finish_line = get_node("../../FinishLine")  # Adjust path as needed
	if finish_line:
		finish_line.player_finished.connect(_on_player_finished)

func _process(delta):
	if is_running:
		var current_time = Time.get_time_dict_from_system()
		var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
		update_timer_display(elapsed)

func start_timer():
	start_time = Time.get_ticks_msec()
	is_running = true
	print("Speedrun timer started!")

func stop_timer():
	if is_running:
		is_running = false
		final_time = (Time.get_ticks_msec() - start_time) / 1000.0
		print("Speedrun finished! Time: ", format_time(final_time))
		
		# Show final time
		if final_time_label:
			final_time_label.text = "Final Time: " + format_time(final_time)
			final_time_label.visible = true
		
		# Hide running timer
		if timer_label:
			timer_label.visible = false

func update_timer_display(time: float):
	if timer_label:
		timer_label.text = format_time(time)

func format_time(time: float) -> String:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

func _on_player_finished():
	stop_timer()
	print("Stopping timer")

func reset_timer():
	is_running = false
	start_time = 0.0
	final_time = 0.0
	if timer_label:
		timer_label.visible = true
		timer_label.text = "00:00.000"
	if final_time_label:
		final_time_label.visible = false
