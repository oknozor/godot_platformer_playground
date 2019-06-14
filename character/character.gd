 extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()
export(String) var sword_path = "" 
var sword = null 
var state
var _current_direction = Direction.RIGHT

const WALK_SPEED = 450
const JUMP = -1000
const GRAVITY = 60

enum Direction { LEFT, RIGHT, UP, DOWN } 
enum State { IDLE, ATTACK } 
func _ready(): 
	sword = $DirectionHelper/SwordSpawn/Sword
	sword.connect("attack_finished", self, "_on_Sword_attack_finished")

func _change_state(new_state): 
	match new_state: 
		State.IDLE:
			continue
		State.ATTACK:
			sword.attack()
	state = new_state
	emit_signal("state_changed", new_state) 
	
func _physics_process(delta) -> void:
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		_current_direction = Direction.LEFT
		motion.x = - WALK_SPEED
	
	elif Input.is_action_pressed("ui_right"):
		_current_direction = Direction.RIGHT
		motion.x = WALK_SPEED
		
	elif Input.is_action_pressed("ui_up"):
		_current_direction = Direction.UP
		
	elif Input.is_action_pressed("ui_down"):
		_current_direction = Direction.DOWN
		
	else:
		motion.x =0 
	if Input.is_action_just_pressed("attack"):
		_change_state(State.ATTACK)
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP
	move_and_slide(motion, UP)


func on_Sword_attack_finished():
	_change_state(State.IDLE)

