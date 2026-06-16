class_name Player extends Node

@export var game_root: Game
@export var farmhouse: Farmhouse
@onready var player_camera: PlayerCamera = $PlayerCamera

func _ready() -> void:
	_setup_tool_mode_manager()
	pass

# -----[[ TOOL MODE API ]]-----
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
	pass

## Activates a tool mode from the specified tool_mode_name.
func activate_tool_mode(tool_mode_name: String):
	tool_mode_manager.switch_tool_mode(tool_mode_name)
	

## Deactivates the current tool mode.
func deactivate_current_tool_mode():
	tool_mode_manager.deactivate_current_tool_mode()
	

## Returns all the registered tool names.
func get_tool_mode_names() -> Array[String]:
	return tool_mode_manager.get_tool_mode_names()


# -----[[ CURRENCY API ]]-----
# This part is meant to store and initalize the CurrencyHandler along with public properties.

# Defining currency handler using PlayerClass signals
var _currency_handler := CurrencyHandler.new(currency_changed, currency_added, currency_removed)

# Currency related signals
signal currency_changed(currency_id: String, previous: int, current: int)
signal currency_added(current_id: String, amount: int)
signal currency_removed(current_id: String, amount: int)

## Returns the amount of a currency.
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
	
# -----[[ INVENTORY API ]]-----
# This part is meant to store and initalize the InventoryHandler along with public properties.
