extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()

const WALK_SPEED = 250
const JUMP = -500
const GRAVITY = 20 



func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		motion.x = - WALK_SPEED
	elif Input.is_action_pressed("ui_right"):
		motion.x = WALK_SPEED 
	else:
		motion.x =0 
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP
		
	move_and_slide(motion, UP)
	pass
	