extends Position2D
var input_direction = Vector2(); 

func _physics_process(delta):
	if input_direction == Vector2():
		return
	
	rotation = input_direction.angle()


func set_direction(direction):
	input_direction = direction