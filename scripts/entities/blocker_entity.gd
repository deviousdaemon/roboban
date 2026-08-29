@tool
class_name BlockerEntity extends Entity

@export var grid_position: Vector2i

func _init(grid_pos: Vector2i = Vector2i()) -> void:
	grid_position = grid_pos
	ECS.world_changed.connect(_on_world_ready.unbind(1))
	#component_added.connect(_on_component_added)
	pass

func _on_world_ready() -> void:
	if Engine.is_editor_hint(): return
	ECS.world.add_entity(self)
	SpatialQuery.register_entity(self, grid_position)

func define_components() -> Array:
	return [
		C_GridPosition.new(grid_position),
		C_Blocking.new()
	]
