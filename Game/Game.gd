extends Node3D

# Node that controls the city
@onready var CityGenerator = $CityGenerator

func _ready() -> void:
	CityGenerator.start_city()
	pass
