class_name Game extends Node3D

# Public references
@export var farmhouse: Farmhouse
@export var city_manager: CityManager
@export var land_handler: LandHandler

func _ready() -> void:
	city_manager.start()
	land_handler.start()
	pass
