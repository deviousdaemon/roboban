class_name C_FacingDirection extends Component

@export var direction: Vector2i = Vector2i.DOWN :
	set(v):
		if direction == v: return
		var old_value: Vector2i = direction
		direction = v
		property_changed.emit(self, "direction", old_value, v)

func _init(dir: Vector2i = Vector2i.DOWN) -> void:
	direction = dir
	pass
