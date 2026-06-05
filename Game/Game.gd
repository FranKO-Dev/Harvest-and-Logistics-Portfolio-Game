extends Node3D

# Node that controls the city
@export var city_manager: CityManager

func _ready() -> void:
	city_manager.start_city()
	pass
