@tool
class_name FloorButton extends RB_Entity

@export_enum("Gray", "Black", "Blue", "Orange", "Yellow", "Caution") var color: int = 0 :
	set(v):
		color = v
		if not sprite_2d: return
		sprite_2d.region_rect.position.x = 32 * v

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_player_activate: AudioStreamPlayer2D = $AudioPlayerActivate
@onready var audio_player_deactivate: AudioStreamPlayer2D = $AudioPlayerDeactivate

func _init() -> void:
	component_property_changed.connect(on_component_property_changed)

func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, _new_value: Variant) -> void:
	if component is C_Trigger:
		sprite_2d.frame_coords.x = 1 if component.active else 0
		if component.active:
			audio_player_activate.play()
		else:
			audio_player_deactivate.play()
	pass
