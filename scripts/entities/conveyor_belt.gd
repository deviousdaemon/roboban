@tool
class_name ConveyorBelt extends RB_Entity

var DIRECTIONS: Array[Vector2i] = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]

@export_enum("Right", "Down", "Left", "Up") var direction: int = 0 :
	set(v):
		direction = v
		if not sprite_2d: return
		sprite_2d.frame_coords.y = v

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer2D = $AudioPlayer

func _ready() -> void:
	direction = direction
	#animation_player.current_animation = "default"
	pass

func _init() -> void:
	component_added.connect(on_component_added)
	component_property_changed.connect(on_component_property_changed)
	pass

func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, _new_value: Variant) -> void:
	if component is C_Trigger:
		if component.active and not animation_player.is_playing():
			animation_player.play("default")
			audio_player.play()
		elif not component.active and animation_player.is_playing():
			animation_player.pause()
			audio_player.stop()
			#animation_player.stop(true)
	pass

func on_component_added(_entity: Entity, component: Resource) -> void:
	if component is C_Conveyor:
		component.direction = DIRECTIONS[direction]
	pass
