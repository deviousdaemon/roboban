extends Node

var spatial_map: Dictionary[Vector2i, Array[Entity]]

func clear() -> void:
	spatial_map.clear()
	pass

func register_entity(entity: Entity, position: Vector2i) -> void:
	if not spatial_map.has(position): spatial_map[position] = []
	spatial_map[position].append(entity)
	pass

func unregister_entity(entity: Entity) -> void:
	for key in spatial_map:
		if spatial_map[key].has(entity):
			spatial_map[key].erase(entity)
	pass

func update_entity(entity: Entity, from: Vector2i, to: Vector2i) -> void:
	if not spatial_map.has(from):
		push_error("Warning! \"from\" had no entity")
	spatial_map[from].erase(entity)
	if not spatial_map.has(to): spatial_map[to] = []
	spatial_map[to].append(entity)
	pass

func get_entities_at(position: Vector2i) -> Array[Entity]:
	if not spatial_map.has(position): return []
	return spatial_map[position].duplicate()

func has_blocker_at(position: Vector2i) -> bool:
	if not spatial_map.has(position): return false
	for entity in spatial_map[position]:
		if entity.has_component(C_Blocking): return true
	return false
