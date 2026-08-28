extends Node

@onready var world: World = %World
@onready var tile_map: LevelTileMap = %TileMap
@onready var win_state_observer: WinStateObserver = %WinStateObserver

func _ready() -> void:
	win_state_observer.level_won.connect(_on_level_won)
	
	ECS.world = world
	
	for position in tile_map.get_wall_positions():
		var wall := Entity.new()
		world.add_entity(wall, [C_GridPosition.new(position), C_Blocking.new()])
		SpatialQuery.register_entity(wall, position)
		pass
	pass

func _process(delta: float) -> void:
	ECS.process(delta)

func _on_level_won() -> void:
	await get_tree().create_timer(0.5).timeout
	print("")
	pass
