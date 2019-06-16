 extends KinematicBody2D
class_name Character

const UP = Vector2(0, -1)
var motion = Vector2()
var sword = null 
var state
var _current_direction = Direction.RIGHT
var controls = null
var friction = false  
const MAX_SPEED = 1000
const ACCELERATION = 50 
const JUMP = -2000
const GRAVITY = 90

export(String) var control_right
export(String) var control_left
export(String) var control_up
export(String) var control_down
export(String) var control_attack

enum Direction { LEFT, RIGHT, UP, DOWN } 
enum State { IDLE, ATTACK, RESPAWN }
	
func _ready(): 
	sword = $DirectionHelper/SwordSpawn/Sword
	sword.connect("attack_finished", self, "_on_Sword_attack_finished")
	$Health.connect("health_changed", self, "_on_Health_health_changed")

func _change_state(new_state): 
	match new_state: 
		State.IDLE:
			continue
		State.ATTACK:
			sword.attack()
		State.RESPAWN:
			self.position = Vector2(0, -1000)
#			self.respawn()
			_change_state(State.IDLE)
	state = new_state
	emit_signal("state_changed", new_state) 

#func respawn():
	
	
	
func _physics_process(delta) -> void:
	motion.y += GRAVITY
	friction = false 
	
	if Input.is_action_pressed(control_left):
		_current_direction = Direction.LEFT
		$DirectionHelper.set_direction(Vector2(1, 0) ) 
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED) 
	
	elif Input.is_action_pressed(control_right):
		_current_direction = Direction.RIGHT
		$DirectionHelper.set_direction(Vector2(-1, 0)) 
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED) 
		
	elif Input.is_action_pressed(control_up):
		$DirectionHelper.set_direction(Vector2(0, 1)) 
		_current_direction = Direction.UP
		
	elif Input.is_action_pressed(control_down):
		$DirectionHelper.set_direction(Vector2(0, -1)) 
		_current_direction = Direction.DOWN
		
	else:
		friction = true
	if Input.is_action_just_pressed(control_attack):
		_change_state(State.ATTACK)
		
	if is_on_floor():
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
		if Input.is_action_pressed(control_up):
			motion.y = JUMP
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
		
	move_and_slide(motion, UP)


func _on_Sword_attack_finished():
	print("attack finished") 
	_change_state(State.IDLE)

func _on_Health_health_changed(new_health):
	if new_health == 0:
		_change_state(State.RESPAWN) 
	
	

