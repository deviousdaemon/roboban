class_name C_GridPosition extends Component

@export var position: Vector2i :
	set(v):
		if v == position: return
		var old_value: Vector2i = position
		position = v
		property_changed.emit(self, "position", old_value, v)

func _init(pos: Vector2i = Vector2i()) -> void:
	position = pos
	pass
