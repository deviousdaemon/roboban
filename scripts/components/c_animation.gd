@tool
class_name C_Animation extends Component

var current_animation_name: StringName = ""

@export var default_animation_name: StringName = ""
@export var animation_conditions: Array[AnimationCondition] = [] :
	set(v):
		if not Engine.is_editor_hint():
			v.sort_custom(_sort_conditions)
		animation_conditions = v

func _sort_conditions(a: AnimationCondition, b: AnimationCondition) -> bool:
	return a.conditions.size() > b.conditions.size()
