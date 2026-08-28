@tool
class_name WallLight extends RB_Entity

@export_enum("Red:1", "Yellow:2", "Green:3", "Blue:4") var color: int = 3

@onready var sprite_2d: Sprite2D = $Sprite2D

func _init() -> void:
	component_property_changed.connect(on_component_property_changed)

func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, _new_value: Variant) -> void:
	if component is C_Trigger:
		sprite_2d.frame_coords.x = color if component.active else 0
	pass
