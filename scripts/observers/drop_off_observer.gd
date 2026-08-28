class_name DropOffObserver extends Observer

func query() -> QueryBuilder:
	return q.with_all([C_BoxType, C_GridPosition, C_Pushable]).on_changed([&"position"])#.with_none([C_ActionLock])

func each(event: Variant, entity: Entity, payload: Variant = null) -> void:
	if not payload.component is C_GridPosition: return
	var box: Box = entity as Box
	if not box: return
	var c_grid_pos: C_GridPosition = entity.get_component(C_GridPosition) as C_GridPosition
	var box_type: C_BoxType = entity.get_component(C_BoxType) as C_BoxType
	match event:
		Observer.Event.CHANGED:
			var entities: Array[Entity] = SpatialQuery.get_entities_at(c_grid_pos.position)
			entities.erase(entity)
			if entities.is_empty():
				return
			for other_entity in entities:
				var drop_off_type: C_DropOffType = other_entity.get_component(C_DropOffType) as C_DropOffType
				if not drop_off_type: continue
				if box_type.type == drop_off_type.type:
					box.slot_in()
					cmd.remove_component(box, C_Pushable)
					cmd.add_component(other_entity, C_Blocking.new())
					break
				pass
