class_name C_Trigger extends Component

@export var active = false :
	set(v):
		if v == active: return
		var old_value: bool = active
		active = v
		property_changed.emit(self, "active", old_value, v)

func _init(is_active: bool = false) -> void:
	active = is_active
	pass
