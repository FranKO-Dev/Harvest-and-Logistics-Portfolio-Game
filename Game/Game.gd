extends Node3D

# Node that controls the city
@export var city_generator: CityGenerator

func _ready() -> void:
	city_generator.start_city()
	pass
