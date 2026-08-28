@tool
extends RB_Entity
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _init() -> void:
	component_property_changed.connect(on_component_property_changed)

func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, new_value: Variant) -> void:
	if component is C_FacingDirection:
		match new_value:
			Vector2i.LEFT:
				sprite_2d.frame_coords.y = 2
				pass
			Vector2i.RIGHT:
				sprite_2d.frame_coords.y = 0
				pass
			Vector2i.UP:
				sprite_2d.frame_coords.y = 3
				pass
			Vector2i.DOWN:
				sprite_2d.frame_coords.y = 1
				pass
		pass
	pass
