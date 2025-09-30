extends Area2D

@export var blow_force: float = 500.0
var bodies_inside: Array[RigidBody2D] = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body is RigidBody2D and body not in bodies_inside:
		bodies_inside.append(body)

func _on_body_exited(body: Node2D):
	if body in bodies_inside:
		bodies_inside.erase(body)

func _physics_process(delta):
	var blow_direction = Vector2.UP.rotated(global_rotation)
	for body in bodies_inside:
		body.apply_central_force(blow_direction * blow_force)
