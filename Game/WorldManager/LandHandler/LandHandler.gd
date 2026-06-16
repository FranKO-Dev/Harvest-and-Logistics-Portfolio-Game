extends Node 
class_name LandHandler

# Component that handles growing for each land
var _land_growing_component = LandGrowingComponent.new()

# Assets scene for a land block 3d
const land_block_prefab = preload("res://Game/WorldManager/LandHandler/LandBlock.tscn")

# Size in meters of a land block
const block_size: int = 3
# Offset to start spawning land
const offset: Vector2 = Vector2(0, -6)

# Emitted after a land block is added, brings the land_index.
signal land_block_added(land_index: Vector2)

func _ready() -> void:
	pass
	

# Starts the land
func start():
	_land_growing_component.start()
	
	add_land_block(Vector2(0, 0))
	add_land_block(Vector2(1, 0)).get_children().any(func(child: Node):
		if child.is_in_group("lands"):
			plant_seed_on_land(child, preload("res://Game/Seeds/WheatSeed.tres"))
		pass)
	add_land_block(Vector2(0, -1))
	

# Spawns a land in the specified index
func add_land_block(land_index: Vector2) -> Node3D:
	var land_block: Node3D = land_block_prefab.instantiate()
	land_block.position = Vector3(land_index.x, 0, land_index.y) * block_size
	land_block.position += Vector3(offset.x, 0, offset.y)
	add_child(land_block)
	
	land_block_added.emit(land_index)
	return land_block
	

## Plants a seed on a land safely, returning status codes for error checking.
## If success, the status code returned is 0 which is same a OK.
func plant_seed_on_land(land: Node3D, plant_seed: PlantSeed) -> Error:
	return _land_growing_component.plant_seed_on_land(land, plant_seed)
	
