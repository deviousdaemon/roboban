class_name C_InputBuffer extends Component

var direction: Vector2i = Vector2i()
var time_remaining: float = 0.0

func set_buffer(dir: Vector2i, buffer_time: float = Globals.INPUT_BUFFER_TIME) -> void:
	direction = dir
	time_remaining = buffer_time
	pass

func is_valid() -> bool:
	return direction != Vector2i() and not is_zero_approx(time_remaining)

func clear() -> void:
	direction = Vector2i()
	time_remaining = 0.0
	pass
