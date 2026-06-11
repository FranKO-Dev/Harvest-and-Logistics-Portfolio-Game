class_name FarmhouseStorage extends RefCounted

var max_capacity: int = 100
signal max_capacity_changed(current_max_capacity)

var plants: Dictionary[Plant, int] = {}


func _init(capacity: int = 100) -> void:
	max_capacity = max(0, capacity)
	

func get_capacity() -> int:
	return max_capacity
	

func set_capacity(new_capacity: int) -> void:
	if new_capacity < max_capacity:
		push_error('new_capacity cannot be smaller than the current max_capacity')
		return
	max_capacity = max(0, new_capacity)
	max_capacity_changed.emit(max_capacity)
	
## Returns the used space in the storage
func get_used_space() -> int:
	var total := 0
	for amount in plants.values():
		total += amount
	return total
	
## Returns the remaining space in the storage
func get_free_space() -> int:
	return max(0, max_capacity - get_used_space())
	

## Returns true if the storage is full
func is_full() -> bool:
	return get_used_space() >= max_capacity
	

## Returns the unit representation of fullness of the storage from the range (0.0) to (1.0).
## When (1.0) means full, and (0.0) means empty.
func get_progress() -> float:
	if max_capacity <= 0:
		return 1.0
	return float(get_used_space()) / float(max_capacity)
	

## Returns the percentage of fullness of the storage from 0% to 100%.
func get_progress_percent() -> float:
	return get_progress() * 100.0
	

## Returns true if a plant is found
func has_plant(plant: Plant) -> bool:
	return plants.has(plant)
	
## Returns the ammout present in the storage of a plant
func get_plant_amount(plant: Plant) -> int:
	return plants.get(plant, 0)
	
## Returns the count of types of plants registered in the storage
func get_unique_plant_count() -> int:
	return plants.size()
	
## Returns a copy of the storage
func get_all_plants() -> Dictionary:
	return plants.duplicate(true)
	

func can_add(amount: int) -> bool:
	return get_used_space() + amount <= max_capacity
	

func add_plant(plant: Plant, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	if not can_add(amount):
		return false
	plants[plant] = get_plant_amount(plant) + amount
	return true
	
	
## Removes the specified amount of plants. Returns the actual removed amount, which is not always
## the same as amount, because sometimes the amount could be bigger than the current amount.
func remove_plant(plant: Plant, amount: int = 1) -> int:
	if amount <= 0 or not plants.has(plant):
		return 0
	
	var current: int = plants[plant]
	var removed: int = mini(amount, current)
	
	if amount >= current:
		# In this case the actual removed amount is different than amount
		plants.erase(plant)
	else:
		plants[plant] = current - removed
	return removed
	

func clear() -> void:
	plants.clear()
	

func is_empty() -> bool:
	return plants.is_empty()
