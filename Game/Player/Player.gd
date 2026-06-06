class_name Player extends Node

@export var farmhouse: Farmhouse

# Initializing currency handler using PlayerClass signals
var _currency_handler := CurrencyHandler.new(currency_changed, currency_added, currency_removed)
var tool_mode_manager := ToolModeManager.new()

# Currency related signals
signal currency_changed(currency_id: String, previous: int, current: int)
signal currency_added(current_id: String, amount: int)
signal currency_removed(current_id: String, amount: int)

func _ready() -> void:
	pass

# Returns the amount of a currency.
func get_currency(currency_id: String) -> int:
	return _currency_handler.get_currency(currency_id)

# Sets a currency amount.
func set_currency(currency_id: String, amount: int):
	_currency_handler.set_currency(currency_id, amount)
	

# Adds currency.
func add_currency(currency_id: String, amount: int):
	_currency_handler.add_currency(currency_id, amount)
	

# Removes currency.
func remove_currency(currency_id: String, amount: int):
	_currency_handler.remove_currency(currency_id, amount)
	

# Returns whether enough currency is available.
func can_afford(currency_id: String, amount: int) -> bool:
	return _currency_handler.can_afford(currency_id, amount)
