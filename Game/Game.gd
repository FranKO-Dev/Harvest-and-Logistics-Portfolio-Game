class_name Game extends Node3D

# Public references
@export var city_manager: CityManager

func _ready() -> void:
	city_manager.start_city()
	pass
