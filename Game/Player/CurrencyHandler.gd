class_name CurrencyHandler extends RefCounted

## Emitted whenever a currency changes.
var currency_changed: Signal
var currency_added: Signal
var currency_removed: Signal

var currencies: Dictionary = {
	"coins": 0,
	"bills": 0,
}

# Initializes the CurrencyHandler, needed external signals to work.
func _init(changed_signal: Signal, added_signal: Signal, removed_signal: Signal):
	currency_changed = changed_signal
	currency_added = added_signal
	currency_removed = removed_signal
	pass

# Returns the amount of a currency.
func get_currency(currency_id: String) -> int:
	return currencies.get(currency_id, 0)

# Returns whether a currency exists.
func has_currency(currency_id: String) -> bool:
	return currencies.has(currency_id)

# Sets a currency amount.
func set_currency(currency_id: String, amount: int) -> void:
	var previous := get_currency(currency_id)

	if previous == amount:
		return

	currencies[currency_id] = amount
	currency_changed.emit(currency_id, previous, amount)

# Adds currency.
func add_currency(currency_id: String, amount: int) -> void:
	set_currency(currency_id, get_currency(currency_id) + amount)
	currency_added.emit(currency_id, amount)

# Removes currency.
func remove_currency(currency_id: String, amount: int) -> void:
	set_currency(currency_id, max(0, get_currency(currency_id) - amount))
	currency_removed.emit(currency_id, amount)

# Returns whether enough currency is available.
func can_afford(currency_id: String, amount: int) -> bool:
	return get_currency(currency_id) >= amount

# Resets all currencies to zero.
func reset() -> void:
	for currency_id in currencies:
		set_currency(currency_id, 0)

# Returns a copy of all currencies.
func get_all() -> Dictionary:
	return currencies.duplicate()
