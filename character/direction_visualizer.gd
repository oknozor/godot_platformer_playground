extends Position2D

func _physics_process(delta):
	var input_direction = Vector2(); 
		
	if Input.is_action_just_pressed("ui_down"):
		input_direction = Vector2(0, -1) 
	elif Input.is_action_just_pressed("ui_up"):
		input_direction = Vector2(0, 1)
	elif Input.is_action_just_pressed("ui_left"):
		input_direction = Vector2(1, 0) 
	elif Input.is_action_just_pressed("ui_right"):
		input_direction = Vector2(-1, 0) 

	if input_direction == Vector2():
		return
	
	rotation = input_direction.angle()
