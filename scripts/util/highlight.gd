extends Node

var highlight_shader := preload("res://resources/highlight.gdshader")

func _process(delta):
	var highlight_on = Input.is_action_pressed("highlight")
	_update_highlight(highlight_on)

func _update_highlight(highlight_on: bool):
	var areas = get_tree().get_nodes_in_group("ground")
	for area in areas:
		for child in area.get_children():
			if child is Polygon2D:
				if highlight_on:
					if not child.material:
						child.material = ShaderMaterial.new()
						child.material.shader = highlight_shader
				else:
					child.material = null
