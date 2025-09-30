extends RigidBody2D

signal finished_level

@export var acceleration: float = 200
@export var max_speed: float = 300.0
@export var min_speed: float = 50

@onready var rock_smash_entrance_sfx: AudioStreamPlayer = $RockSmashEntranceSFX
@onready var rock_smash_exit_sfx: AudioStreamPlayer = $RockSmashExitSFX

var is_in_ground = false
var default_gravity_scale: float

func _ready():
	add_to_group("player")
	lock_rotation = true
	default_gravity_scale = gravity_scale

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	
	if is_in_ground:
		gravity_scale = 0
		linear_velocity += direction * acceleration * delta
	else:
		gravity_scale = default_gravity_scale
	
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	if linear_velocity.length() < min_speed and linear_velocity.length() > 0 and is_in_ground:
		linear_velocity = linear_velocity.normalized() * min_speed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		is_in_ground = true
		rock_smash_entrance_sfx.play();
		$Camera.shake(2)
	
	if area.is_in_group("finish"):
		finished_level.emit()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("ground"):
		is_in_ground = false
		rock_smash_exit_sfx.play();
		$Camera.shake(2)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
