class_name WinStateObserver extends Observer

signal level_won

var drop_off_points: Array[DropOffPoint]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var drop_off_point: DropOffPoint = entity as DropOffPoint
		if drop_off_point:
			drop_off_points.append(drop_off_point)
	pass

func query() -> QueryBuilder:
	return q.with_all([C_Blocking, C_DropOffType]).on_added().with_none([C_ActionLock])

func each(event: Variant, _entity: Entity, _payload: Variant = null) -> void:
	match event:
		Observer.Event.ADDED:
			if check_win_state():
				level_won.emit()
			pass

func check_win_state() -> bool:
	for drop_off_point in drop_off_points:
		if not drop_off_point.has_component(C_Blocking):
			return false
	return true
