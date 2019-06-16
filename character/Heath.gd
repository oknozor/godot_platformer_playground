extends Node

var health = 0
signal health_changed
export(int) var max_health = 1 

func _ready():
	health = max_health


func take_damage(amount):
	print("taking damage")
	health -= amount 
	if health < 0: 
		health = 0
	emit_signal("health_changed", health)
	print("%s took %s damage :  %s/%s"  % [get_path(), amount, health, max_health])
	
func recover_health(amount):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health)
	print("%s recoverd %s life :  %s/%s"  % [get_path(), amount, health, max_health])

