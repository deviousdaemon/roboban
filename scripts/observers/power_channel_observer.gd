class_name PowerChannelObserver extends Observer

var receiver_entities: Dictionary[int, Array[Entity]]

func _ready() -> void:
	ECS.world_changed.connect(_on_world_ready.unbind(1))

func _on_world_ready() -> void:
	for entity in _world.entities:
		var receiver: C_Receiver = entity.get_component(C_Receiver) as C_Receiver
		if receiver:
			if receiver.channel == -1:
				var receiver_trigger: C_Trigger = entity.get_component(C_Trigger) as C_Trigger
				if not receiver_trigger: continue
				receiver_trigger.active = true
			else:
				if not receiver_entities.has(receiver.channel):
					receiver_entities[receiver.channel] = []
				receiver_entities[receiver.channel].append(entity)
	pass

func query() -> QueryBuilder:
	return q.with_all([C_Trigger, C_Transmitter]).on_changed([&"active"])

func each(event: Variant, entity: Entity, payload: Variant = null) -> void:
	if receiver_entities.is_empty(): return
	match event:
		Observer.Event.CHANGED:
			var trigger: C_Trigger = payload.component as C_Trigger
			var transmitter: C_Transmitter = entity.get_component(C_Transmitter) as C_Transmitter
			if not trigger or not transmitter: return
			if not receiver_entities.has(transmitter.channel): return
			for receiver_entity in receiver_entities[transmitter.channel]:
				var receiver_trigger: C_Trigger = receiver_entity.get_component(C_Trigger) as C_Trigger
				if not receiver_trigger: continue
				receiver_trigger.active = trigger.active
				pass
			pass
