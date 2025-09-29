extends CharacterBody2D

signal finished_level

@export var acceleration: float = 200
@export var max_speed: float = 300.0
@export var min_speed: float = 50
@export var gravity: float = 5.0

var is_in_ground = false

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	if is_in_ground:
		velocity += direction * acceleration * delta
	else: 
		velocity.y += gravity
	
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	if velocity.length() < min_speed:
		velocity = velocity.normalized() * min_speed
		
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		is_in_ground = true
	
	if area.is_in_group("finish"):
		finished_level.emit()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("ground"):
		is_in_ground = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
