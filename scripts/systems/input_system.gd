class_name InputSystem extends System

func query() -> QueryBuilder:
	return q.with_all([C_GridPosition, C_InputBuffer])

func process(entities: Array[Entity], _components: Array, delta: float) -> void:
	var movement_input: Vector2i
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		movement_input.x = -1 if Input.is_action_pressed("move_left") else 1
	elif Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down"):
		movement_input.y = -1 if Input.is_action_pressed("move_up") else 1
	
	
	
	#if movement_input != Vector2i():
		#
		#pass
	
	
	
	for entity in entities:
		var facing: C_FacingDirection = entity.get_component(C_FacingDirection) as C_FacingDirection
		if facing:
			facing.direction = movement_input
		
		var buffer: C_InputBuffer = entity.get_component(C_InputBuffer) as C_InputBuffer
		
		if movement_input != Vector2i():
			buffer.set_buffer(movement_input)
		else:
			if buffer.is_valid():
				if buffer.time_remaining > 0.0:
					buffer.time_remaining -= delta
				else:
					buffer.clear()
		
		var action_lock: C_ActionLock = entity.get_component(C_ActionLock) as C_ActionLock
		if action_lock: continue
		
		var move_intent: C_MovementIntent = entity.get_component(C_MovementIntent) as C_MovementIntent
		
		if buffer.is_valid() and not move_intent:
			cmd.add_component(entity, C_MovementIntent.new(buffer.direction))
			buffer.clear()
			pass
		
		pass
	pass
