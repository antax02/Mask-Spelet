extends CanvasLayer

@onready var color_rect = ColorRect.new()

const FADE_COLOR = Color(0.05, 0.05, 0.1, 1.0)
const FADE_DURATION = 0.4

func _ready():
	color_rect.color = FADE_COLOR
	color_rect.modulate.a = 0.0
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	add_child(color_rect)
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	fade_in()

func fade_out() -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "modulate:a", 1.0, FADE_DURATION)
	await tween.finished

func fade_in() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "modulate:a", 0.0, FADE_DURATION)
	await tween.finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene(scene_path: String) -> void:
	await fade_out()
	get_tree().change_scene_to_file(scene_path)
	await fade_in()
