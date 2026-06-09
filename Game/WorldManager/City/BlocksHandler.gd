class_name BlocksHandler extends Node

var building_asset = preload("res://Objects/Decoration/Houses.tscn")
var park_asset = preload("res://Objects/Decoration/Park.tscn")
var road_asset = preload("res://Objects/Roads/Intersection/FourLanes.tscn")
var market_asset = preload("res://Objects/Markets/Classic/BaseMarket.tscn")

# frecuency a Market must be generated after an x ammount of buildings
var market_frequency = 7
var buildings_before_market: int = 0

var park_frequency = 7
var buildings_before_park: int = 0

# Places and renders a block on the 3D space.
# Returts a list of generated Markets on the block.
func place_block(
	block_index: Vector2, block_size: int, 
	generated_block: Array[Array], _neighbors: Array[Vector2] = []) -> Array:
	
	var offset = Vector2(0.5, block_size/2.0)
	
	# Empty Node to group all the objects inside of it
	var Block = Node3D.new();
	var block_position = block_index * (block_size) + offset
	add_child(Block)
	Block.position = Vector3(block_position.x, 0, block_position.y)
	
	
	# List of generated markets on the block
	var MarketArray: Array[Node3D] = []
	
	# Checking if the block is in front the Farmhouse, normally located in front of 0,0
	if (block_index.y == 0):
		place_road_block(self, Vector2(block_position.x, -offset.x), Vector2(block_size, 1))
	
	# Generating buildings
	for x in range(block_size):
		for y in range(block_size):
			var local_position = Vector2(x, y) - Vector2(block_size/2.0, block_size/2.0)
			var position = local_position
			
			var is_building = generated_block[x][y] == " "
			if is_building:
				if buildings_before_market >= market_frequency:
					buildings_before_market = 0;
					# Spawning Market
					MarketArray.append(place_market(Block, position))
				else:
					buildings_before_market += 1;
					place_decoration(Block, position)
			else:
				place_road(Block, position)
			pass
	return MarketArray

# Places a decoration on a block
func place_decoration(parent: Node3D, position: Vector2):
	var object: Node3D
	
	if buildings_before_park >= park_frequency:
		buildings_before_park = 0
		object = park_asset.instantiate()
	else:
		object = building_asset.instantiate()
		buildings_before_park += 1
	
	object.position = Vector3(position.x, 0, position.y)
	object.rotate_y(randi_range(0,3) * PI/2.0)
	parent.add_child(object)
	pass
	
# Places a block of roads
func place_road_block(parent: Node, position: Vector2, block_size: Vector2):
	for x in range(block_size.x):
		for y in range(block_size.y):
			var road_position = position + Vector2(x, y) - block_size/2.0
			place_road(parent, road_position)
	pass

func place_road(parent: Node, position: Vector2):
	var object: Node3D = road_asset.instantiate()
	object.position = Vector3(position.x, 0, position.y)
	object.rotate_y(randi_range(0,3) * PI/2.0)
	parent.add_child(object)
	pass
	
func place_market(parent: Node, position: Vector2) -> Node3D:
	var market: Node3D = market_asset.instantiate()
	market.position = Vector3(position.x, 0, position.y)
	market.rotate_y(randi_range(0,3) * PI/2.0)
	parent.add_child(market)
	return market
