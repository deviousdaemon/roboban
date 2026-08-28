@tool
class_name ComponentCondition extends Resource

@export_enum("NULL") var component: String
@export var property: String = ""
@export var value: Variant
@export var remove_after_processing: bool = false

func _validate_property(prop: Dictionary) -> void:
	if prop.name == "component":
		prop.hint_string = _get_component_class_name_hint_string()

func _get_component_class_name_hint_string() -> String:
	var class_list_hint: String = ""
	for c_info in ProjectSettings.get_global_class_list():
		if (c_info.class as String).begins_with("C_"):
			class_list_hint += c_info.class + ","
			
	return class_list_hint.substr(0, class_list_hint.length() - 1)
