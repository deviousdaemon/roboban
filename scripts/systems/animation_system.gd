class_name AnimationSystem extends System

func query() -> QueryBuilder:
	return q.with_all([C_Animation]).with_none([C_ActionLock])

func process(entities: Array[Entity], _components: Array, _delta: float) -> void:
	for entity in entities:
		var anim_component: C_Animation = entity.get_component(C_Animation) as C_Animation
		#var conditions_match: bool = false
		
		var anim_player: AnimationPlayer = entity.get("animation_player") as AnimationPlayer
		if not anim_player: continue
		
		for anim_condition in anim_component.animation_conditions:
			var cond_check: Dictionary = _check_condition(anim_condition, entity.components.values())
			if cond_check.matches:
				for component in cond_check.to_remove:
					cmd.remove_component(entity, component)
				anim_player.play(anim_condition.animation_name)
				if anim_condition.locks_actions:
					cmd.add_component(entity, C_ActionLock.new())
					anim_player.animation_finished.connect(cmd.remove_component.bind(entity, C_ActionLock).unbind(1), CONNECT_ONE_SHOT)
				if not anim_player.animation_finished.is_connected(anim_player.stop.unbind(1)):
					anim_player.animation_finished.connect(anim_player.stop.unbind(1), CONNECT_ONE_SHOT)
				break
		pass

func _check_condition(anim_condition: AnimationCondition, components: Array) -> Dictionary:
	var conditions_matched: int = 0
	var components_to_remove: Array[Component]
	for condition in anim_condition.conditions:
		for component in components:
			if ((component as Component).get_script() as Script).get_global_name() == condition.component:
				if condition.property.is_empty():
					conditions_matched += 1
					if condition.remove_after_processing:
						components_to_remove.append(component)
				elif component.get(condition.property) == condition.value:
					conditions_matched += 1
					if condition.remove_after_processing:
						components_to_remove.append(component)
				break
	return {
		"matches": conditions_matched == anim_condition.conditions.size(),
		"to_remove": components_to_remove
}
