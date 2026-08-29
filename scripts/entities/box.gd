@tool
class_name Box extends RB_Entity

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var type: Globals.BoxTypes = Globals.BoxTypes.CARDBOARD :
	set(v):
		type = v
		if not sprite_2d: return
		sprite_2d.frame_coords.y = int(v)

func _init() -> void:
	component_added.connect(_on_component_added)

func _ready() -> void:
	type = type
	pass

func _on_component_added(_entity: Entity, component: Resource) -> void:
	if component is C_BoxType:
		component.type = type
	pass

func slot_in() -> void:
	add_component(C_ActionLock.new())
	animation_player.play("slot_in")
	animation_player.animation_finished.connect(remove_component.bind(C_ActionLock).unbind(1), CONNECT_ONE_SHOT)
	pass
