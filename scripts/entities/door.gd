@tool
class_name Door extends RB_Entity

signal open_finished
signal close_finished

const DOORS_VERTICAL_TEXTURE: Texture2D = preload("uid://bebsvtofbn06x")
const DOORS_HORIZONTAL_TEXTURE: Texture2D = preload("uid://blj6h1xq2hmug")

@onready var sprite_2d_top: Sprite2D = $Sprite2DTop
@onready var sprite_2d_middle: Sprite2D = $Sprite2DMiddle
@onready var sprite_2d_bottom: Sprite2D = $Sprite2DBottom


var tween: Tween = null

@export var is_vertical: bool = false :
	set(v):
		is_vertical = v
		if not is_node_ready(): return
		_update_sprite()

func _init() -> void:
	component_added.connect(_on_component_added)
	#component_property_changed.connect(on_component_property_changed)

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

func _on_component_added(_entity: Entity, component: Resource) -> void:
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

#func on_component_property_changed(_entity: Entity, component: Resource, _property_name: String, _old_value: Variant, _new_value: Variant) -> void:
	#if component is C_Trigger:
		#if tween:
			#tween.kill()
		#tween = get_tree().create_tween()
		#if component.active:
			#tween.tween_property(sprite_2d, "frame_coords:x", 12, Globals.TIME_TO_MOVE)
			#if has_component(C_Blocking):
				#tween.finished.connect(remove_component.bind(C_Blocking))
		#else:
			#tween.tween_property(sprite_2d, "frame_coords:x", 0, Globals.TIME_TO_MOVE)
			#if not has_component(C_Blocking):
				#tween.finished.connect(add_component.bind(C_Blocking.new()))
			#
		#pass
	#pass

func update_tween() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()

func open() -> void:
	update_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite_2d_top, "frame_coords:" + "x" if is_vertical else "y", 12, Globals.TIME_TO_MOVE / 2)
	tween.tween_property(sprite_2d_middle, "frame_coords:" + "x" if is_vertical else "y", 12, Globals.TIME_TO_MOVE / 2)
	tween.tween_property(sprite_2d_bottom, "frame_coords:" + "x" if is_vertical else "y", 12, Globals.TIME_TO_MOVE / 2)
	if has_component(C_Blocking):
		remove_component(C_Blocking)
		#tween.finished.connect(remove_component.bind(C_Blocking))
	#tween.finished.connect(open_finished.emit, CONNECT_ONE_SHOT)
	pass

func close() -> void:
	update_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite_2d_top, "frame_coords:" + "x" if is_vertical else "y", 0, Globals.TIME_TO_MOVE / 2)
	tween.tween_property(sprite_2d_middle, "frame_coords:" + "x" if is_vertical else "y", 0, Globals.TIME_TO_MOVE / 2)
	tween.tween_property(sprite_2d_bottom, "frame_coords:" + "x" if is_vertical else "y", 0, Globals.TIME_TO_MOVE / 2)
	if not has_component(C_Blocking):
		add_component(C_Blocking.new())
		#tween.finished.connect(add_component.bind(C_Blocking.new()))
	#tween.finished.connect(close_finished.emit, CONNECT_ONE_SHOT)
	pass

func _update_sprite() -> void:
	sprite_2d_top
	sprite_2d_bottom
	
	sprite_2d_top.texture = DOORS_VERTICAL_TEXTURE if is_vertical else DOORS_HORIZONTAL_TEXTURE
	sprite_2d_middle.texture = DOORS_VERTICAL_TEXTURE if is_vertical else DOORS_HORIZONTAL_TEXTURE
	sprite_2d_bottom.texture = DOORS_VERTICAL_TEXTURE if is_vertical else DOORS_HORIZONTAL_TEXTURE
	
	sprite_2d_top.position = Vector2()
	sprite_2d_bottom.position = Vector2()
	
	sprite_2d_top.vframes = 1
	sprite_2d_middle.vframes = 1
	sprite_2d_bottom.vframes = 1
	sprite_2d_top.hframes = 1
	sprite_2d_middle.hframes = 1
	sprite_2d_bottom.hframes = 1
	
	if is_vertical:
		sprite_2d_top.position.y = -16
		sprite_2d_bottom.position.y = 16
		
		sprite_2d_top.region_rect = Rect2(0, 0, 208, 16)
		sprite_2d_middle.region_rect = Rect2(0, 16, 208, 16)
		sprite_2d_bottom.region_rect = Rect2(0, 32, 208, 16)
		
		sprite_2d_top.hframes = 13
		sprite_2d_middle.hframes = 13
		sprite_2d_bottom.hframes = 13
		
	else:
		sprite_2d_top.position.x = -16
		sprite_2d_bottom.position.x = 16
		
		sprite_2d_top.region_rect = Rect2(0, 0, 16, 208)
		sprite_2d_middle.region_rect = Rect2(16, 0, 16, 208)
		sprite_2d_bottom.region_rect = Rect2(32, 0, 16, 208)
		
		sprite_2d_top.vframes = 13
		sprite_2d_middle.vframes = 13
		sprite_2d_bottom.vframes = 13
	pass

