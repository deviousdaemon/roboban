class_name SwitchObserver extends Observer

var switches: Array[FloorSwitch]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var switch: FloorSwitch = entity as FloorSwitch
		if switch:
			switches.append(switch)
	pass

func query() -> QueryBuilder:
	return q.with_all([C_GridPosition, C_Blocking]).on_changed([&"position"]).with_none([C_ActionLock])

func each(_event: Variant, _entity: Entity, _payload: Variant = null) -> void:
	if switches.is_empty(): return
	for switch in switches:
		var switch_grid_pos: C_GridPosition = switch.get_component(C_GridPosition) as C_GridPosition
		if not C_GridPosition: continue
		var trigger: C_Trigger = switch.get_component(C_Trigger) as C_Trigger
		if not trigger: continue
		var has_blocker_at_position: bool = false
		for entity in SpatialQuery.get_entities_at(switch_grid_pos.position):
			if entity.has_component(C_Blocking):
				has_blocker_at_position = true
				break
		trigger.active = has_blocker_at_position
	pass
