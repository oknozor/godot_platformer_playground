extends Area2D
signal teleport

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies: 
	emit_signal("teleport")
		

	