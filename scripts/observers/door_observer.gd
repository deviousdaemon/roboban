class_name DoorObserver extends Observer

var doors: Array[Door]
var doors_waiting_to_close: Dictionary[Vector2i, Door]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var door: Door = entity as Door
		if door:
			doors.append(door)
	pass

func sub_observers() -> Array[Array]:
	return [
		[q.with_all([C_Door, C_Trigger]).on_changed([&"active"]), _door_trigger_changed],
		[q.with_all([C_GridPosition, C_Blocking]).with_none([C_ActionLock]).on_changed([&"position"]), _on_blocker_grid_position_changed]
	]

#func  query() -> QueryBuilder:
	#return q.with_all([C_Door, C_Trigger]).changed([&"active"])

func _door_trigger_changed(event: Variant, entity: Entity, payload: Variant = null) -> void:
	match event:
		Observer.Event.CHANGED:
			var door: Door = entity as Door
			if not door: return
			var trigger_active: bool = payload.new_value as bool
			if trigger_active:
				
				door.open()
				#if door.has_component(C_Blocking):
					#door.open_finished.connect(cmd.remove_component.bind(door, C_Blocking))
					#cmd.remove_component(door, C_Blocking)
			else:
				var c_grid_pos: C_GridPosition = door.get_component(C_GridPosition) as C_GridPosition
				if not c_grid_pos:
					push_error("No Grid Poisition component found!")
					print()
					return
				if SpatialQuery.has_blocker_at(c_grid_pos.position):
					doors_waiting_to_close[c_grid_pos.position] = door
				else:
					door.close()
					#if not door.has_component(C_Blocking):
						#door.open_finished.connect(cmd.add_component.bind(door, C_Blocking.new()))
	pass

func _on_blocker_grid_position_changed(event: Variant, entity: Entity, payload: Variant = null) -> void:
	if doors_waiting_to_close.is_empty(): return
	match event:
		Observer.Event.CHANGED:
			if payload.property == "position":
				var old_grid_position: Vector2i = payload.old_value
				if not doors_waiting_to_close.has(old_grid_position): return
				if payload.new_value != old_grid_position:
					var door: Door = doors_waiting_to_close[old_grid_position]
					door.close()
					#if not door.has_component(C_Blocking):
						#door.open_finished.connect(cmd.add_component.bind(door, C_Blocking.new()))
					pass
				pass
	pass












