class_name PushValidationSystem extends System

func query() -> QueryBuilder:
	return q.with_all([C_GridPosition, C_MovementIntent]).with_none([C_ActionLock])

func process(entities: Array[Entity], _components: Array, _delta: float) -> void:
	for entity in entities:
		var grid_pos: C_GridPosition = entity.get_component(C_GridPosition) as C_GridPosition
		var movement: C_MovementIntent = entity.get_component(C_MovementIntent) as C_MovementIntent
		var next_position: Vector2i = grid_pos.position + movement.direction
		var pushable_entity: Entity = null
		
		var neighbors: Array[Entity] = SpatialQuery.get_entities_at(next_position)
		
		
		for neighbor in neighbors:
			var pushable: C_Pushable = neighbor.get_component(C_Pushable) as C_Pushable
			var n_grid_pos: C_GridPosition = neighbor.get_component(C_GridPosition) as C_GridPosition
			if pushable and n_grid_pos:
				pushable_entity = neighbor
				break
		if pushable_entity:
			var push_grid_pos: C_GridPosition = pushable_entity.get_component(C_GridPosition)
			next_position = push_grid_pos.position + movement.direction
			var has_blocking: bool = false
			for neighbor in SpatialQuery.get_entities_at(next_position):
				if neighbor.has_component(C_Blocking):
					has_blocking = true
					break
			if has_blocking:
				cmd.remove_component(entity, C_MovementIntent)
				cmd.add_component(entity, C_PushFailIntent.new(movement.direction))
			else:
				cmd.add_component(pushable_entity, C_MovementIntent.new(movement.direction))
				cmd.add_component(entity, C_PushIntent.new())
		else:
			var has_blocking: bool = false
			for neighbor in neighbors:
				if neighbor.has_component(C_Blocking):
					has_blocking = true
					break
			if has_blocking:
				cmd.remove_component(entity, C_MovementIntent)
				#cmd.add_component(entity, C_ActionLock.new())
				# TODO player push fail anim
				cmd.add_component(entity, C_PushFailIntent.new(movement.direction))
	pass
