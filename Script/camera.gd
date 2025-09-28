extends Camera2D

# Reference to the player/object we're following
@export var target: Node2D
# Base zoom level when stationary
@export var base_zoom: Vector2 = Vector2(1.0, 1.0)
# Maximum zoom out amount
@export var max_zoom_out: float = 0.3
# Speed at which zoom changes happen
@export var zoom_smoothness: float = 5.0
# Velocity threshold - above this speed, zoom starts changing
@export var velocity_threshold: float = 50.0
# Maximum velocity for full zoom effect
@export var max_velocity: float = 500.0

func _ready():
	# If no target is set, try to find the player
	if not target:
		target = get_node("../Player")  # Adjust path as needed
	
	# Set initial zoom
	zoom = base_zoom

func _process(delta):
	if not target:
		return
	
	# Get the target's velocity (assuming it has a velocity property)
	var velocity_magnitude = 0.0
	
	# Try different common velocity property names
	if target.has_method("get_velocity"):
		velocity_magnitude = target.get_velocity().length()
	elif "velocity" in target:
		velocity_magnitude = target.velocity.length()
	elif target.has_method("get_linear_velocity"):
		velocity_magnitude = target.get_linear_velocity().length()
	
	# Calculate zoom factor based on velocity
	var zoom_factor = calculate_zoom_factor(velocity_magnitude)
	
	# Target zoom level
	var target_zoom = base_zoom - Vector2(zoom_factor, zoom_factor)
	
	# Smoothly interpolate to target zoom
	zoom = zoom.lerp(target_zoom, zoom_smoothness * delta)

func calculate_zoom_factor(velocity_mag: float) -> float:
	# Only start zooming out if above threshold
	if velocity_mag <= velocity_threshold:
		return 0.0
	
	# Normalize velocity to 0-1 range
	var normalized_velocity = (velocity_mag - velocity_threshold) / (max_velocity - velocity_threshold)
	normalized_velocity = clamp(normalized_velocity, 0.0, 1.0)
	
	# Apply easing for smoother transition
	normalized_velocity = ease_out_quad(normalized_velocity)
	
	return normalized_velocity * max_zoom_out

func ease_out_quad(t: float) -> float:
	return 1.0 - (1.0 - t) * (1.0 - t)
