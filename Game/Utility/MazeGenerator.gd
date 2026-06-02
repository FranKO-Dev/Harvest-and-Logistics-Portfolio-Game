extends Object

# Characters used to represed diferent objects inside the maze.
var wall_character = "X"
var empty_character = " "
var point_a_character = "A"
var point_b_character = "B"

# All four possible orthogonal directions
const all_directions = [
	[2, 0], [-2, 0], [0, 2], [0, -2]
]

# Validates the size, <size> must be a odd positive integer
# greater than 3. Returns true if validated.
func validate_size(size: int) -> bool:
	# If size is lower than tree then size is not valid.
	if size < 3:
		return false
	# Determinating if the size divided by two results in a perfect division.
	var is_pair = size % 2 == 0
	return not is_pair

# Returns a 2d array with <size> dimentions
# full of <wall_character> that will be used as a teomplate.
func initialize_maze(size: int) -> Array[Array]:
	# Initializing maze template as an empty array.
	var full_maze: Array[Array] = []
	# Filling the empty array with arrays of <wall_character>
	for x in range(size):
		# Creating row with <size> amount of <wall_character>
		var maze_row: Array[String] = []
		for y in range(size):
			maze_row.append(wall_character)
		# Appending row to full maze.
		full_maze.append(maze_row)
		pass
	
	return full_maze

# Recursively carves the maze using Deep first search from all possibles positions.
func carve_maze(maze: Array[Array], size: int, position_x: int, position_y: int) -> void:
	# Carving current position
	maze[position_x][position_y] = empty_character
	
	# Carving maze from all directions and randomizing order using fisher-yates algorithm.
	var directions = all_directions.duplicate(true)
	for a in range(directions.size() - 1, 0, -1):
		# Defining temp variables before swapping
		var b = randi_range(0, a)
		var tmp = directions[b]
		# Swapping positions
		directions[b] = directions[a]; directions[a] = tmp
		pass
	
	# Trying all shuffled directions
	for dir in directions:
		var dir_x = dir[0]; var dir_y = dir[1]
		# New position
		var new_x = position_x + dir_x; var new_y = position_y + dir_y
		# Validating new position
		if not is_inside_maze_frame(size, new_x, new_y):
			continue
		if maze[new_x][new_y] == wall_character:
			# Carving in-between cell
			var between_x = position_x + int(dir_x/2);
			var between_y = position_y + int(dir_y/2)
			maze[between_x][between_y] = empty_character
			# Carving all directions from the new cell
			carve_maze(maze, size, new_x, new_y)
	pass

# Returns true if a position is inside the the maze frame.

func is_inside_maze_frame(size: int, x: int, y: int):
	var size_index: int = size - 1
	if is_clipping_maze_frame(size, x, y):
		return false
	var is_out_of_bounds = (
		(x < 0 or x > size_index) or
		(y < 0 or y > size_index)
	)
	return not is_out_of_bounds

# Returns true if a position is cliping a maze frame.
func is_clipping_maze_frame(size: int, x: int, y: int):
	var size_index: int = size - 1
	var clipping_maze_frame = (
		(y == 0 or x == 0) or 
		(y == size_index or x == size_index)
	)
	return clipping_maze_frame

# Returns a maze represented as a 2d array.
# It requires a size and a seed, <size> must be always a odd 
# positive integer greater than 3, or else it will return null.
func create_maze_2d(size: int) -> Variant:
	if not validate_size(size):
		return null
		
	# Creating 2d array with no empty spaces.
	var maze = initialize_maze(size)
	# Carving the maze at starting point
	var start_x = 1; var start_y = 1
	carve_maze(maze, size, start_x, start_y)
	
	# Assining point a at starting point
	maze[start_x][start_y] = point_a_character
	return maze

func debug_maze(maze: Array) -> void:
	print("Maze contents: ", maze)
