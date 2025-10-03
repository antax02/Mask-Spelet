extends Node


func spawn_smash(pos: Vector2, direction: Vector2, parent: Node):
	var p = CPUParticles2D.new()
	parent.add_child(p)
	
	p.global_position = pos + (direction * 5)
	
	p.amount = 20
	p.lifetime = 0.3
	p.one_shot = true
	p.emitting = true
	p.speed_scale = 2.0
	
	p.direction = direction
	p.spread = 40
	p.initial_velocity_min = 200
	p.initial_velocity_max = 500
	
	p.gravity = Vector2(0, 200)
	p.scale_amount_min = 3.0
	p.scale_amount_max = 6.0
	p.color = Color(0.459, 0.392, 0.325, 1.0)
	
	p.z_index = 1
	
	await p.finished
	p.queue_free()
