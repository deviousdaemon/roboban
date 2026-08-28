@tool
class_name RB_Entity extends Entity

func _ready() -> void:
	var grid_pos: C_GridPosition = get_component(C_GridPosition) as C_GridPosition
	if grid_pos:
		grid_pos.position = (global_position / float(Globals.GRID_SIZE)).floor()
		SpatialQuery.register_entity(self, grid_pos.position)

