extends Node2D

@export var segment_count: int = 20
@export var segment_length: float = 20.0
@export var segment_radius: float = 10.0
@export var head_radius: float = 15.0
@export var max_angle_per_segment: float = PI / 4

@export_group("Colors")
@export var worm_color: Color = Color(0.75, 0.50, 0.50)
@export var outline_color: Color = Color(0.50, 0.30, 0.30)
@export var band_color: Color = Color(0.85, 0.70, 0.60)
@export var outline_width: float = 2.0

@export_group("Details")
@export var band_segment_index: int = 4
@export var tail_taper_length: int = 5

var segments: Array[Vector2] = []

func _ready():
	for i in range(segment_count):
		segments.append(global_position + Vector2(0, i * segment_length))

func _process(_delta: float):
	update_worm_segments()
	queue_redraw()

func update_worm_segments():
	var parent = get_parent()
	if not parent or segments.is_empty():
		return
	
	segments[0] = parent.global_position
	
	for i in range(1, segments.size()):
		var to_previous = segments[i - 1] - segments[i]
		if to_previous.length() < 0.001:
			to_previous = Vector2.DOWN * segment_length
		
		var target_position = segments[i - 1] - to_previous.normalized() * segment_length
		
		if i >= 2:
			var prev_direction = (segments[i - 1] - segments[i - 2]).normalized()
			var proposed_direction = (target_position - segments[i - 1]).normalized()
			var angle_between = prev_direction.angle_to(proposed_direction)
			
			if abs(angle_between) > max_angle_per_segment:
				var constrained_angle = sign(angle_between) * max_angle_per_segment
				proposed_direction = proposed_direction.rotated(constrained_angle - angle_between)
				target_position = segments[i - 1] + proposed_direction * segment_length
		
		segments[i] = target_position

func _draw():
	if segments.size() < 2:
		return
	
	var radii = _calculate_radii()
	var colors = _calculate_colors()
	
	_draw_outline(radii)
	_draw_body(radii, colors)
	_draw_head_features(radii)

func _calculate_radii() -> Array:
	var radii = []
	var taper_start = segments.size() - tail_taper_length
	
	for i in range(segments.size()):
		var radius = head_radius if i == 0 else segment_radius
		
		if i >= taper_start:
			var taper_progress = remap(i, taper_start, segments.size() - 1, 0.0, 1.0)
			radius *= lerp(1.0, 0.1, taper_progress)
		
		radii.append(radius)
	return radii

func _calculate_colors() -> Array:
	var colors = []
	for i in range(segments.size()):
		colors.append(band_color if i == band_segment_index else worm_color)
	return colors

func _draw_outline(radii: Array):
	for i in range(1, segments.size()):
		var p_front = to_local(segments[i-1])
		var p_back = to_local(segments[i])
		var r_front = radii[i-1] + outline_width
		var r_back = radii[i] + outline_width
		
		var dir = (p_front - p_back).normalized()
		if dir.length_squared() == 0:
			continue
		
		var perp = dir.orthogonal()
		var verts = PackedVector2Array([
			p_front + perp * r_front, p_back + perp * r_back,
			p_back - perp * r_back, p_front - perp * r_front
		])
		draw_polygon(verts, PackedColorArray([outline_color]))
	
	for i in range(segments.size()):
		if radii[i] > 0:
			draw_circle(to_local(segments[i]), radii[i] + outline_width, outline_color)

func _draw_body(radii: Array, colors: Array):
	for i in range(1, segments.size()):
		var p_front = to_local(segments[i-1])
		var p_back = to_local(segments[i])
		var r_front = radii[i-1]
		var r_back = radii[i]
		
		var dir = (p_front - p_back).normalized()
		if dir.length_squared() == 0:
			continue
		
		var perp = dir.orthogonal()
		var verts = PackedVector2Array([
			p_front + perp * r_front, p_back + perp * r_back,
			p_back - perp * r_back, p_front - perp * r_front
		])
		draw_polygon(verts, PackedColorArray([colors[i-1]]))
	
	for i in range(segments.size()):
		if radii[i] > 0:
			draw_circle(to_local(segments[i]), radii[i], colors[i])

func _draw_head_features(radii: Array):
	if segments.size() < 2 or radii[0] < outline_width:
		return
	
	var local_pos = to_local(segments[0])
	var direction = (segments[0] - segments[1]).normalized()
	if direction.length_squared() == 0:
		return
	
	var radius = radii[0]
	var eye_radius = radius * 0.2
	var perpendicular = direction.orthogonal()
	var eye_base_pos = local_pos + direction * radius * 0.4
	
	var left_eye_pos = eye_base_pos - perpendicular * radius * 0.45
	var right_eye_pos = eye_base_pos + perpendicular * radius * 0.45
	
	draw_circle(left_eye_pos, eye_radius, Color.WHITE)
	draw_circle(right_eye_pos, eye_radius, Color.WHITE)
	
	var mouse_pos = get_global_mouse_position()
	var pupil_radius = eye_radius * 0.5
	var max_pupil_offset = eye_radius * 0.4
	
	var left_eye_global = to_global(left_eye_pos)
	var left_to_mouse = (mouse_pos - left_eye_global).normalized()
	var left_pupil_offset = left_to_mouse * max_pupil_offset
	draw_circle(left_eye_pos + left_pupil_offset, pupil_radius, Color.BLACK)
	
	var right_eye_global = to_global(right_eye_pos)
	var right_to_mouse = (mouse_pos - right_eye_global).normalized()
	var right_pupil_offset = right_to_mouse * max_pupil_offset
	draw_circle(right_eye_pos + right_pupil_offset, pupil_radius, Color.BLACK)
