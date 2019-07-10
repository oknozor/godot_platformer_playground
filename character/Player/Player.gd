extends "res://character/Character.gd"

signal state_changed 


const GRAVITY = 100
const MAX_SPEED = 1000
const ACCELERATION = 50 
const JUMP = - 300
const JUMP_CAP = - 1750

onready var sword = self.get_node("DirectionHelper/SwordSpawn/Sword")
onready var health = self.get_node("Health")
var state
var _current_direction = Direction.RIGHT
var friction = false 

var motion = Vector2()
var can_jump = true 

# Controls
export(String) onready var control_right
export(String) onready var control_left
export(String) onready var control_up
export(String) onready var control_down
export(String) onready var control_jump
export(String) onready var control_attack


enum State { IDLE, ATTACK, HIT, RESPAWN, JUMP, JUMP_CONSUMED }


func _ready(): 
	sword.connect("attack_finished", self, "_on_Sword_attack_finished")
	health.connect("health_changed", self, "_on_Health_health_changed")



func _change_state(new_state): 
	match new_state: 
		State.IDLE:
			print("unimplemented")
		State.ATTACK:
			sword.attack()
			
		
	state = new_state
	emit_signal("state_changed", new_state) 



func _physics_process(delta) -> void:
	motion.y += GRAVITY
	friction = false 
	_process_input_direction()

	if Input.is_action_just_pressed(control_attack):
		_change_state(State.ATTACK)
	
	_process_physics()
		
	move_and_slide(motion, UP)



func _process_input_direction(): 
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


func _process_physics():
	if is_on_floor():
		motion.y = 0
		
		if friction == true:
			motion.x *= 0.8
		if Input.is_action_just_pressed(control_jump):
			motion.y += JUMP
		can_jump = true
	elif is_on_ceiling():
		Input.action_release(control_jump)
		motion.y = 0 
	else:
		if can_jump and motion.y > JUMP_CAP and Input.is_action_pressed(control_jump):
			print("motion Y :", motion.y) 
			motion.y += JUMP
		elif motion.y < JUMP_CAP or Input.is_action_just_released(control_jump):  
			can_jump = false
		if friction == true:
			motion.x *= 0.95


# Signals 
func _on_Sword_attack_finished():
	print("attack finished") 
	_change_state(State.IDLE)

func _on_Health_health_changed(new_health):
		_change_state(State.HIT) 
