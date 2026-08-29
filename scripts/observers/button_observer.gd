class_name ButtonObserver extends Observer

var buttons: Array[FloorButton]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var button: FloorButton = entity as FloorButton
		if button:
			buttons.append(button)
	pass

func query() -> QueryBuilder:
	return q.with_all([C_GridPosition, C_Blocking]).on_changed([&"position"]).with_none([C_ActionLock])

func each(_event: Variant, _entity: Entity, _payload: Variant = null) -> void:
	if buttons.is_empty(): return
	for button in buttons:
		var button_grid_pos: C_GridPosition = button.get_component(C_GridPosition) as C_GridPosition
		if not C_GridPosition: continue
		var trigger: C_Trigger = button.get_component(C_Trigger) as C_Trigger
		if not trigger: continue
		var has_blocker_at_position: bool = false
		for entity in SpatialQuery.get_entities_at(button_grid_pos.position):
			if entity.has_component(C_Blocking):
				has_blocker_at_position = true
				break
		trigger.active = has_blocker_at_position
	pass
