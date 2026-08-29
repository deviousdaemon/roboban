@tool
class_name Door extends RB_Entity

const DOORS_VERTICAL_TEXTURE: Texture2D = preload("uid://bebsvtofbn06x")
const DOORS_HORIZONTAL_TEXTURE: Texture2D = preload("uid://blj6h1xq2hmug")

@onready var sprite_2d: Sprite2D = $Sprite2D

var tween: Tween = null

@export var is_vertical: bool = false :
	set(v):
		is_vertical = v
		if not sprite_2d: return
		_update_sprite()

func _init() -> void:
	component_added.connect(_on_component_added)
	component_property_changed.connect(on_component_property_changed)

func _ready() -> void:
	is_vertical = is_vertical
	if Engine.is_editor_hint(): return
	
	
	var grid_position: Vector2i = (global_position / float(Globals.GRID_SIZE)).floor()
	
	if is_vertical:
		add_child(BlockerEntity.new(grid_position + Vector2i(0, -1)))
		add_child(BlockerEntity.new(grid_position + Vector2i(0, 1)))
		pass
	else:
		add_child(BlockerEntity.new(grid_position + Vector2i(-1, 0)))
		add_child(BlockerEntity.new(grid_position + Vector2i(1, 1)))
	pass

func _on_component_added(entity: Entity, component: Resource) -> void:
	if component is C_Trigger:
		if component.active:
			if has_component(C_Blocking):
				remove_component(C_Blocking)
			pass
		else:
			if not has_component(C_Blocking):
				add_component(C_Blocking.new())
			pass
			
	pass

func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, _new_value: Variant) -> void:
	if component is C_Trigger:
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		if component.active:
			tween.tween_property(sprite_2d, "frame_coords:x", 12, Globals.TIME_TO_MOVE)
		else:
			tween.tween_property(sprite_2d, "frame_coords:x", 0, Globals.TIME_TO_MOVE)
			
		pass
	pass

func _update_sprite() -> void:
	sprite_2d.texture = DOORS_VERTICAL_TEXTURE if is_vertical else DOORS_HORIZONTAL_TEXTURE
	sprite_2d.offset = Vector2()
	if is_vertical:
		sprite_2d.offset.y = -16
	else:
		sprite_2d.offset.x = -16
	pass

