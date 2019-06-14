extends Node

static func get_input_direction(event = Input):
	return Vector2(
			float(event.is_action_pressed("move_right")),
			float(event.is_action_pressed("move_down"))).normalized()
