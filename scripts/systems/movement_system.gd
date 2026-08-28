class_name MovementSystem extends System



func query() -> QueryBuilder:
	return q.with_all([C_GridPosition, C_MovementIntent]).with_none([C_ActionLock])

func process(entities: Array[Entity], _components: Array, _delta: float) -> void:
	for entity in entities:
		var c_grid_pos: C_GridPosition = entity.get_component(C_GridPosition) as C_GridPosition
		var c_movement: C_MovementIntent = entity.get_component(C_MovementIntent) as C_MovementIntent
		cmd.remove_component(entity, C_MovementIntent)
		var new_position = c_grid_pos.position + c_movement.direction
		#SpatialQuery.update_entity(entity, c_grid_pos.position, new_position)
		
		#c_grid_pos.position += c_movement.direction
		
		cmd.add_component(entity, C_ActionLock.new())
		
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(entity, "global_position", Vector2((new_position) * Globals.GRID_SIZE), Globals.TIME_TO_MOVE)
		#tween.finished.connect(cmd.remove_component.bind(entity, C_ActionLock), CONNECT_ONE_SHOT)
		tween.finished.connect(on_tween_finished.bind(entity, c_grid_pos, c_grid_pos.position, new_position), CONNECT_ONE_SHOT)
		#tween.finished.connect(SpatialQuery.update_entity.bind(entity, c_grid_pos.position, new_position), CONNECT_ONE_SHOT)
		#tween.finished.connect(c_grid_pos.set.bind("position", new_position), CONNECT_ONE_SHOT)
		tween.finished.connect(tween.kill, CONNECT_ONE_SHOT)
		pass
	pass

func on_tween_finished(entity: Entity, c_grid_pos: C_GridPosition, old_position: Vector2i, new_position: Vector2i) -> void:
	SpatialQuery.update_entity(entity, old_position, new_position)
	cmd.remove_component(entity, C_ActionLock)
	#entity.remove_component(C_ActionLock)
	cmd.add_custom(c_grid_pos.set.bind("position", new_position))
	#c_grid_pos.position = new_position
	pass
