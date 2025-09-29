extends Node2D

# Worm configuration
@export var segment_count: int = 20  # Number of segments in the worm
@export var segment_length: float = 20.0  # Distance between segments
@export var segment_radius: float = 15.0  # Visual radius of each segment
@export var head_radius: float = 20.0  # Slightly bigger head
@export var worm_color: Color = Color(0.8, 0.3, 0.3)  # Reddish color
@export var outline_color: Color = Color(0.6, 0.2, 0.2)
@export var outline_width: float = 2.0

# --- New Visual Properties ---
@export_group("Visual Details")
@export var band_segment_index: int = 4 # Which segment gets the band (from the head)
@export var band_color: Color = Color(0.9, 0.8, 0.5) # Light yellow for the band
@export var segment_detail_color: Color = Color(0.6, 0.2, 0.2) # Darker red for lines

# Angle constraint (in radians)
@export var max_angle_per_segment: float = PI / 6  # Maximum bend between segments (30 degrees)

# Internal worm data
var segments: Array[Vector2] = []  # Positions of each segment

func _ready():
	# Initialize the worm segments in a straight line
	for i in range(segment_count):
		var initial_pos = global_position + Vector2(0, i * segment_length)
		segments.append(initial_pos)
	
	set_process(true)

func _process(_delta: float):
	update_worm_segments()
	queue_redraw()

func update_worm_segments():
	
	var parent = get_parent()
	if not parent:
		return
	
	# Head follows parent directly
	if segments.size() > 0:
		segments[0] = parent.global_position
	
	# Each segment follows the previous one with constraints
	for i in range(1, segments.size()):
		var previous_segment = segments[i - 1]
		var current_segment = segments[i]
		
		# Calculate unconstrained target position
		var to_previous = previous_segment - current_segment
		if to_previous.length() < 0.001:
			to_previous = Vector2.DOWN * segment_length
		
		to_previous = to_previous.normalized() * segment_length
		var target_position = previous_segment - to_previous
		
		# Apply angle constraint for segments after the second one
		if i >= 2:
			# Get the actual angle from i-2 to i-1
			var prev_prev_segment = segments[i - 2]
			var prev_direction = (previous_segment - prev_prev_segment).normalized()
			
			# Get the proposed direction from i-1 to new position
			var proposed_direction = (target_position - previous_segment).normalized()
			
			# Calculate angle between these directions
			var angle_between = prev_direction.angle_to(proposed_direction)
			
			# If angle is too large, constrain it
			if abs(angle_between) > max_angle_per_segment:
				# Rotate the proposed direction to be within limits
				var constrained_angle = sign(angle_between) * max_angle_per_segment
				var rotation = constrained_angle - angle_between
				proposed_direction = proposed_direction.rotated(rotation)
				
				# Update target position with constrained direction
				target_position = previous_segment + (proposed_direction * segment_length)
		
		# Update segment position
		segments[i] = target_position

func _draw():
	# This function draws the worm in layers for a clean, cartoon look:
	# 1. Pre-calculation of geometry
	# 2. Body Outline (drawn first as a larger, solid shape)
	# 3. Body Fill (drawn on top of the outline, leaving a border)
	# 4. Segment Details
	# 5. Head Features (Eyes) - Drawn last to be on top.
	
	if segments.size() < 2:
		return

	# --- Step 1: Pre-calculate all radii and colors ---
	# This avoids recalculating the tapering and band color in every drawing step.
	var radii = []
	var colors = []
	for i in range(segments.size()):
		var is_head = (i == 0)
		var is_band = (i == band_segment_index)
		var radius = head_radius if is_head else segment_radius
		var current_color = worm_color
		if is_band:
			current_color = band_color
		
		# Tail Tapering
		var tail_length = 5
		var taper_start_index = segments.size() - tail_length
		if i >= taper_start_index:
			var taper_progress = remap(i, taper_start_index, segments.size() - 1, 0.0, 1.0)
			radius *= lerp(1.0, 0.1, taper_progress)
		
		radii.append(radius)
		colors.append(current_color)

	# --- Step 2: Draw the complete body outline ---
	# This is drawn FIRST as a larger, solid-colored shape.
	for i in range(1, segments.size()):
		var p_front = to_local(segments[i-1])
		var p_back = to_local(segments[i])
		var r_front = radii[i-1] + outline_width
		var r_back = radii[i] + outline_width

		var dir = (p_front - p_back).normalized()
		if dir.length_squared() == 0: continue
		var perp = dir.orthogonal()

		var outline_verts = PackedVector2Array([
			p_front + perp * r_front, p_back + perp * r_back,
			p_back - perp * r_back, p_front - perp * r_front
		])
		draw_polygon(outline_verts, PackedColorArray([outline_color]))
	# Second, draw circles at each joint to create smooth, rounded connections.
	for i in range(segments.size()):
		if radii[i] > 0:
			draw_circle(to_local(segments[i]), radii[i] + outline_width, outline_color)

	# --- Step 3: Draw the complete body fill on TOP of the outline ---
	# This smaller shape is drawn over the outline, leaving the border visible.
	for i in range(1, segments.size()):
		var p_front = to_local(segments[i-1])
		var p_back = to_local(segments[i])
		var r_front = radii[i-1]
		var r_back = radii[i]
		
		var dir = (p_front - p_back).normalized()
		if dir.length_squared() == 0: continue
		var perp = dir.orthogonal()
		
		var fill_color = colors[i-1]
		var fill_verts = PackedVector2Array([
			p_front + perp * r_front, p_back + perp * r_back,
			p_back - perp * r_back, p_front - perp * r_front
		])
		draw_polygon(fill_verts, PackedColorArray([fill_color]))
	for i in range(segments.size()):
		if radii[i] > 0:
			draw_circle(to_local(segments[i]), radii[i], colors[i])

	# --- Step 4: Draw segment detail lines on top of the fill ---
	for i in range(1, segments.size()):
		if i == band_segment_index:
			continue
			
		var radius = radii[i]
		if radius < outline_width:
			continue
		
		var local_pos = to_local(segments[i])
		var direction = (segments[i-1] - segments[i]).normalized()
		if direction.length_squared() == 0:
			continue
		
		var perp = direction.orthogonal()
		var start_point = local_pos - perp * radius
		var end_point = local_pos + perp * radius
		draw_line(start_point, end_point, segment_detail_color, outline_width)

	# --- Step 5: Draw head features on top of everything ---
	if segments.size() > 1:
		var local_pos = to_local(segments[0])
		var radius = radii[0]
		
		if radius < outline_width:
			return

		var direction = (segments[0] - segments[1]).normalized()
		if direction.length_squared() == 0:
			return
			
		var eye_forward_offset = radius * 0.4
		var eye_sideways_offset = radius * 0.45
		var eye_radius = radius * 0.2
		var pupil_radius = eye_radius * 0.5
		
		var perpendicular = direction.orthogonal()
		var eye_base_pos = local_pos + direction * eye_forward_offset
		
		var left_eye_pos = eye_base_pos - perpendicular * eye_sideways_offset
		var right_eye_pos = eye_base_pos + perpendicular * eye_sideways_offset
		
		draw_circle(left_eye_pos, eye_radius, Color.WHITE)
		draw_circle(right_eye_pos, eye_radius, Color.WHITE)
		draw_circle(left_eye_pos, pupil_radius, Color.BLACK)
		draw_circle(right_eye_pos, pupil_radius, Color.BLACK)

func get_segment_global_position(index: int) -> Vector2:
	if index >= 0 and index < segments.size():
		return segments[index]
	return Vector2.ZERO

func get_head_position() -> Vector2:
	if segments.size() > 0:
		return segments[0]
	return global_position

func get_tail_position() -> Vector2:
	if segments.size() > 0:
		return segments[-1]
	return global_position
