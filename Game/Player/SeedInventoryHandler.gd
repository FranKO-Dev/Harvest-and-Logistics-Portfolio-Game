class_name SeedInventoryHandler
extends RefCounted

signal inventory_changed
signal seed_added(seed: PlantSeed, amount: int, new_total: int)
signal seed_removed(seed: PlantSeed, amount: int, remaining: int)
signal inventory_cleared

var seeds: Dictionary[PlantSeed, int] = {}

## Returns true if a plant seed is found
func has_seed(plant_seed: PlantSeed) -> bool:
	return seeds.has(plant_seed)

## Returns the amount present in the storage of a plant seed
func get_plant_amount(plant_seed: PlantSeed) -> int:
	return seeds.get(plant_seed, 0)

## Returns the count of unique plant seed types registered in storage
func get_unique_plant_count() -> int:
	return seeds.size()

## Returns a copy of the storage
func get_all_plants() -> Dictionary:
	return seeds.duplicate(true)

func add_plant(plant_seed: PlantSeed, amount: int = 1) -> bool:
	if amount <= 0:
		return false

	var new_total := get_plant_amount(plant_seed) + amount
	seeds[plant_seed] = new_total

	seed_added.emit(plant_seed, amount, new_total)
	inventory_changed.emit()

	return true

## Removes the specified amount of plant seeds. Returns the actual removed amount.
func remove_plant_seed(plant_seed: PlantSeed, amount: int = 1) -> int:
	if amount <= 0 or not seeds.has(plant_seed):
		return 0

	var current: int = seeds[plant_seed]
	var removed: int = mini(amount, current)
	var remaining := current - removed

	if remaining <= 0:
		seeds.erase(plant_seed)
		remaining = 0
	else:
		seeds[plant_seed] = remaining

	seed_removed.emit(plant_seed, removed, remaining)
	inventory_changed.emit()

	return removed

func clear() -> void:
	if seeds.is_empty():
		return

	seeds.clear()

	inventory_cleared.emit()
	inventory_changed.emit()

func is_empty() -> bool:
	return seeds.is_empty()

## Returns the total number of seeds stored across all types
func get_total_seed_count() -> int:
	var total := 0
	for amount in seeds.values():
		total += amount
	return total

## Overwrites the seeds dictionary for a new one
func overwrite_seeds(new_seeds: Dictionary[PlantSeed, int]):
	seeds = new_seeds
	inventory_changed.emit()
	
