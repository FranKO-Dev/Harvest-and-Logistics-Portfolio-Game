class_name Farmhouse extends Node3D

## Increment that will be used to calcualate the storage per level
const level_storage_increment = 50;

## Storage for the farmhouse
var _storage: FarmhouseStorage = FarmhouseStorage.new()
signal storage_capacity_changed(new_max_capacity: int)

## Level of the farmhouse
var farmhouse_level: int = 0;
signal farmhouse_level_changed(new_level: int)
signal farmhouse_level_up(new_level)

func _init() -> void:
	_storage.max_capacity_changed.connect(storage_capacity_changed.emit)
	pass

## Sets a new farmhouse level changing farmhouse's attributes
func set_farmhouse_level(new_level: int):
	_storage.set_capacity(calculate_storage_capacity_at(new_level))
	farmhouse_level = new_level; farmhouse_level_changed.emit(farmhouse_level)
	pass

## Levels up one level ahead from the farmhouse current level safely.
func level_up():
	set_farmhouse_level(farmhouse_level + 1)
	farmhouse_level_up.emit(farmhouse_level)

## Returns true if a plant is in the inventory
func is_plant_in_storage(plant: Plant):
	# Code to check for inventory
	return _storage.has_plant(plant)

## Returns the current max capacity of the storage
func get_storage_capacity() -> int:
	return _storage.get_capacity()

## Calculates and returns the the storage capacity the storage must have at certain level.
func calculate_storage_capacity_at(level: int) -> int:
	return level_storage_increment * int(pow(maxi(level, 1), 2))
