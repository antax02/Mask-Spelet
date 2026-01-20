extends Control

@onready var time_label = $TimeLabel
@onready var animationplayer = $"../Escape menu/AnimationPlayer"
var start_time: float = 0.0
var is_running: bool = true

func _ready():
	start_time = Time.get_ticks_msec()
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.finished_level.connect(_on_player_finished)

func _process(_delta):
	if is_running:
		var elapsed = (Time.get_ticks_msec() - start_time) / 1000.0
		time_label.text = format_time(elapsed)

func _on_player_finished():
	is_running = false
	var final_time = (Time.get_ticks_msec() - start_time) / 1000.0
	time_label.text = "Final Time: " + format_time(final_time)
	PauseManager.final_time = final_time;
	animationplayer.play("finish")

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

func change_to_outro():
	SceneTransition.change_scene("res://scenes/levels/outro.tscn")
