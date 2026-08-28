class_name ConveyorObserver extends Observer

var conveyors: Array[ConveyorBelt]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var conveyor: ConveyorBelt = entity as ConveyorBelt
		if conveyor:
			conveyors.append(conveyor)
	pass

func sub_observers() -> Array[Array]:
	return [
		[q.with_all([C_Pushable, C_GridPosition]).with_none([C_ActionLock]).on_changed([&"position"]), _grid_position_changed],
		[q.with_all([C_Trigger, C_Conveyor]).on_changed([&"active"]), _trigger_changed]
	]

#func query() -> QueryBuilder:
	#return q.with_all([C_Pushable, C_GridPosition]).changed([&"position"]).with_none([C_ActionLock, C_MovementIntent])

func _grid_position_changed(event: Variant, entity: Entity, payload: Variant = null) -> void:
	if conveyors.is_empty(): return
	match event:
		Observer.Event.CHANGED:
			var grid_pos: C_GridPosition = payload.component as C_GridPosition
			if not grid_pos: return
			var entities: Array[Entity] = SpatialQuery.get_entities_at(grid_pos.position)
			var conveyor: ConveyorBelt = null
			var c_conveyor: C_Conveyor = null
			for spatial_entity in entities:
				if spatial_entity is ConveyorBelt:
					if conveyors.has(spatial_entity):
						c_conveyor = spatial_entity.get_component(C_Conveyor) as C_Conveyor
						var trigger: C_Trigger = spatial_entity.get_component(C_Trigger) as C_Trigger
						if not c_conveyor or not trigger: continue
						if not trigger.active: continue
						conveyor = spatial_entity
						break
			if not conveyor: return
			cmd.add_component(entity, C_MovementIntent.new(c_conveyor.direction))
			
			pass

func _trigger_changed(event: Variant, entity: Entity, payload: Variant = null) -> void:
	if conveyors.is_empty(): return
	match event:
		Observer.Event.CHANGED:
			if payload.new_value == false: return
			var grid_pos: C_GridPosition = entity.get_component(C_GridPosition) as C_GridPosition
			var c_conveyor: C_Conveyor = entity.get_component(C_Conveyor) as C_Conveyor
			if not grid_pos or not c_conveyor: return
			for other_entity in SpatialQuery.get_entities_at(grid_pos.position):
				if other_entity.has_component(C_ActionLock) or other_entity.has_component(C_MovementIntent): continue
				if other_entity.has_component(C_GridPosition) and other_entity.has_component(C_Pushable):
					cmd.add_component(other_entity, C_MovementIntent.new(c_conveyor.direction))
					pass
	
	pass
