extends Area2D

@export var fade_rect: ColorRect
@export var next_scene: PackedScene
@export var fade_duration: float = 2.5

var realtime_timer: Timer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	# setup real time timer
	realtime_timer = Timer.new()
	realtime_timer.one_shot = true
	realtime_timer.wait_time = fade_duration
	realtime_timer.ignore_time_scale = true
	add_child(realtime_timer)

	# ensure the rect starts invisible
	if fade_rect:
		fade_rect.modulate.a = 0.0
		fade_rect.visible = true

func _process(delta: float) -> void:
	if realtime_timer.time_left > 0.0:
		# calculate how far along in real time we are
		var k = 1.0 - (realtime_timer.time_left / fade_duration)
		fade_rect.modulate.a = clampf(k, 0.0, 1.0)
		Engine.time_scale = lerp(1.0, 0.0, k)

func _on_body_entered(body: Node) -> void:
	if body.name != "Player":
		return

	# start the real time fade
	realtime_timer.start()

	# ensure we don’t retrigger
	body_entered.disconnect(_on_body_entered)

	# optionally prevent further movement or input
