extends Camera2D

var shake_strength: float = 0.0
var shake_decay: float = 5.0

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_decay * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

func shake(strength: float):
	shake_strength = strength
