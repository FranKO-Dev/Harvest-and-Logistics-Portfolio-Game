extends Control

## Variable that points to the player (required)
@export var player: Player

func _ready() -> void:
	assert(player, "Must have a <player> value")
