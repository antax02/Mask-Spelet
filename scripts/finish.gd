extends Area2D

signal player_finished

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Check if the body is in the "player" group
	if body.is_in_group("player"):
		print("Player reached finish line!")
		player_finished.emit()
