class_name Player
extends Node

@export var game_root: Game
@export var farmhouse: Farmhouse
@export var land_handler: LandHandler

@onready var player_camera: PlayerCamera = $PlayerCamera

func _ready() -> void:
	_setup_tool_mode_manager()
	_setup_seed_inventory_handler()



#region TOOL MODE API
# This part is meant to store and initalize the ToolModeManager along with public properties.

# Defining tool mode manager, passing external nodes and signals.
@onready var tool_mode_manager: ToolModeManager = $ToolModeManager

# Tool signals
signal on_tool_mode_activate(tool_mode_name: String)
signal on_tool_mode_deactivate(tool_mode_name: String)

## Setups connects for tool manager
func _setup_tool_mode_manager():
	tool_mode_manager.on_activate.connect(on_tool_mode_activate.emit)
	tool_mode_manager.on_deactivate.connect(on_tool_mode_deactivate.emit)

## Activates a tool mode from the specified tool_mode_name.
func activate_tool_mode(tool_mode_name: String):
	tool_mode_manager.switch_tool_mode(tool_mode_name)

## Deactivates the current tool mode.
func deactivate_current_tool_mode():
	tool_mode_manager.deactivate_current_tool_mode()

## Returns all the registered tool names.
func get_tool_mode_names() -> Array[String]:
	return tool_mode_manager.get_tool_mode_names()

#endregion



#region CURRENCY API
# This part is meant to store and initalize the CurrencyHandler along with public properties.

# Defining currency handler using PlayerClass signals
var _currency_handler := CurrencyHandler.new(currency_changed, currency_added, currency_removed)

# Currency related signals
signal currency_changed(currency_id: String, previous: int, current: int)
signal currency_added(current_id: String, amount: int)
signal currency_removed(current_id: String, amount: int)

# Returns the amount of a currency.
func get_currency(currency_id: String) -> int:
	return _currency_handler.get_currency(currency_id)

## Sets a currency amount.
func set_currency(currency_id: String, amount: int) -> void:
	_currency_handler.set_currency(currency_id, amount)

## Adds currency.
func add_currency(currency_id: String, amount: int) -> void:
	_currency_handler.add_currency(currency_id, amount)

## Removes currency.
func remove_currency(currency_id: String, amount: int) -> void:
	_currency_handler.remove_currency(currency_id, amount)

## Returns whether enough currency is available.
func can_afford(currency_id: String, amount: int) -> bool:
	return _currency_handler.can_afford(currency_id, amount)

#endregion



#region SEED INVENTORY API
# This part is meant to store and initialize the SeedInventoryHandler
# along with public properties.

# Defining seed inventory handler
var _seed_inventory_handler: SeedInventoryHandler = SeedInventoryHandler.new()

# Seed inventory related signals
signal seed_inventory_changed
signal seed_added(seed: PlantSeed, amount: int, new_total: int)
signal seed_removed(seed: PlantSeed, amount: int, remaining: int)
signal seed_inventory_cleared

# Exposes signals from _seed_inventory_handler
func _setup_seed_inventory_handler() -> void:
	_seed_inventory_handler.inventory_changed.connect(seed_inventory_changed.emit)
	_seed_inventory_handler.seed_added.connect(seed_added.emit)
	_seed_inventory_handler.seed_removed.connect(seed_removed.emit)
	_seed_inventory_handler.inventory_cleared.connect(seed_inventory_cleared.emit)

## Returns true if a plant seed is found
func has_seed(plant_seed: PlantSeed) -> bool:
	return _seed_inventory_handler.has_seed(plant_seed)

## Returns the amount of a specific plant seed
func get_seed_amount(plant_seed: PlantSeed) -> int:
	return _seed_inventory_handler.get_plant_amount(plant_seed)

## Returns the count of unique plant seed types
func get_unique_seed_count() -> int:
	return _seed_inventory_handler.get_unique_plant_count()

## Returns a copy of all stored seeds
func get_all_seeds() -> Dictionary:
	return _seed_inventory_handler.get_all_plants()

## Adds seeds to the inventory
func add_seed(plant_seed: PlantSeed, amount: int = 1) -> bool:
	return _seed_inventory_handler.add_plant(plant_seed, amount)

## Removes seeds from the inventory.
## Returns the actual amount removed.
func remove_seed(plant_seed: PlantSeed, amount: int = 1) -> int:
	return _seed_inventory_handler.remove_plant_seed(plant_seed, amount)

## Clears the inventory
func clear_seed_inventory() -> void:
	_seed_inventory_handler.clear()

## Returns true if the inventory is empty
func is_seed_inventory_empty() -> bool:
	return _seed_inventory_handler.is_empty()

## Returns the total number of seeds across all types
func get_total_seed_count() -> int:
	return _seed_inventory_handler.get_total_seed_count()
	

#endregion



#region PLANTING API
# This intended section is used to store methods, variables related
# to planting/inventory and harvesting.

## Plants a seed on a land spending the plant seed from the inventory.
func plant_seed_on_land(land: Node3D, plant_seed: PlantSeed) -> Error:
	if has_seed(plant_seed):
		var result = land_handler.spawn_seed_on_land(land, plant_seed)
		if result == OK:
			remove_seed(plant_seed)
		return result
	else:
		return ERR_UNAVAILABLE
	

#endregion
