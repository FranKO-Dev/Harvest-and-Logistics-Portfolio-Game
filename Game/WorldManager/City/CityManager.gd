extends Node
class_name CityManager

# Module we'll use to generate our city, where each maze is a block.
var maaze_generator = preload("res://Game/Utility/MazeGenerator.gd").new()
const all_directions: Array = [[1, 0], [-1, 0], [0, -1], [0, 1]]

# City generation constants, generating blocks at the sides or down
const generate_directions: Array = [
	[1, 0], [-1, 0], [0, 1]
]

# Block dimentions
const block_size: int = 7;

@export var blocks_handler: BlocksHandler
@export var pathways_handler: PathwaysHandler

# Block registry where the block index is stored as key.
# Used to check if a block has block neighbors.
var black_registry: Dictionary[Vector2, bool] = {}

# Fired when a Marked has been generated
#signal market_added(Market: Node)

func _ready() -> void:
	pass
	
func start_city():
	if not is_node_ready():	await ready
	generate_block(Vector2(0, 0))
	generate_block(Vector2(-1, 0))
	generate_block(Vector2(1, 0))
	generate_block(Vector2(-1, 1))
	generate_block(Vector2(1, 1))
	generate_block(Vector2(0, 1))
	pass

# Generates a block in the specified index
func generate_block(block_index: Vector2):
	if block_exists(block_index):
		push_warning("Block already exists.")
		return
	# Block with empty spaces and walls, where walls are the roads.
	var generated_block = maaze_generator.create_maze_2d(block_size)
	blocks_handler.place_block(block_index, block_size, generated_block)
	
	registrer_block(block_index)
	pass

func block_exists(block_index: Vector2):
	return black_registry.has(block_index)

func registrer_block(block_index: Vector2):
	black_registry[block_index] = true;
	pass







#
