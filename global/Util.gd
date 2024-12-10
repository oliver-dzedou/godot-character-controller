extends Node

func create_timer(duration: float, callback: Callable):
		var timer = get_tree().create_timer(duration)
		timer.timeout.connect(callback)

func get_normalised_direction(direction: float) -> float:
	if direction < 0:
		return -1
	if direction > 0:
		return 1
	return 0

func get_shape_bounds(shape: CollisionShape2D):
	var shape_pos = shape.global_position
	var rect_shape = shape.shape as RectangleShape2D
	var extents = rect_shape.extents
	
	var left = shape_pos.x - extents.x
	var right = shape_pos.x + extents.x
	var top = shape_pos.y - extents.y
	var bottom = shape_pos.y + extents.y
	
	return { "left": left, "right": right, "top": top, "bottom": bottom }
