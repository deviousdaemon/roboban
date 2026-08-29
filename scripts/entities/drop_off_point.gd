@tool
class_name DropOffPoint extends RB_Entity

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var type: Globals.BoxTypes = Globals.BoxTypes.CARDBOARD :
	set(v):
		type = v
		if not sprite_2d: return
		sprite_2d.frame_coords.x = int(v)

func _ready() -> void:
	type = type
	pass

func define_components() -> Array: return [
	C_GridPosition.new(),
	C_DropOffType.new(type)
]
