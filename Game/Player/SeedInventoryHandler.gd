class_name SeedInventoryHandler extends RefCounted

var seeds: Dictionary[PlantSeed, int] = {}

func _init() -> void:
	pass

## Returns true if a plant seed is found
func has_seed(plant_seed: PlantSeed) -> bool:
	return seeds.has(plant_seed)

## Returns the amount present in the storage of a plant
func get_plant_amount(plant_seed: PlantSeed) -> int:
	return seeds.get(plant_seed, 0)

## Returns the count of types of plant seeds registered in the storage
func get_unique_plant_count() -> int:
	return seeds.size()

## Returns a copy of the storage
func get_all_plants() -> Dictionary:
	return seeds.duplicate(true)

func add_plant(plant_seed: PlantSeed, amount: int = 1) -> bool:
	if amount <= 0:
		return false

	seeds[plant_seed] = get_plant_amount(plant_seed) + amount
	return true

## Removes the specified amount of plant seeds. Returns the actual removed amount.
func remove_plant_seed(plant_seed: PlantSeed, amount: int = 1) -> int:
	if amount <= 0 or not seeds.has(plant_seed):
		return 0

	var current: int = seeds[plant_seed]
	var removed: int = mini(amount, current)

	if amount >= current:
		seeds.erase(plant_seed)
	else:
		seeds[plant_seed] = current - removed

	return removed

func clear() -> void:
	seeds.clear()

func is_empty() -> bool:
	return seeds.is_empty()

## Returns the total number of seeds stored across all types
func get_total_seed_count() -> int:
	var total := 0
	for amount in seeds.values():
		total += amount
	return total
