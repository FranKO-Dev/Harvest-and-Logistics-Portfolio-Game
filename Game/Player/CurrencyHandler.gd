extends Node

# Node meant for handling currencies in-game

# Coins currency
var coins: int = 0:
	set(new_value):
		var last = coins; coins = new_value
		coins_changed.emit(last, coins)
signal coins_changed(last: int, current: int)

# Bills currency
var bills: int = 0:
	set(new_value):
		var last = bills; bills = new_value
		bills_changed.emit(last, bills)
signal bills_changed(last: int, current: int)
