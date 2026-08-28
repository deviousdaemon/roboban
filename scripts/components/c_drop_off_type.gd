class_name C_DropOffType extends Component

@export var type: Globals.BoxTypes = Globals.BoxTypes.CARDBOARD

func _init(box_type: Globals.BoxTypes = Globals.BoxTypes.CARDBOARD) -> void:
	type = box_type
	pass
