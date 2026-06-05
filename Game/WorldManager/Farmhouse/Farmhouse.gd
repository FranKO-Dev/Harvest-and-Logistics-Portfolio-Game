extends Node3D

@export var land_handler: LandHandler

# Returns true if a plant is in the inventory
func is_plant_in_inventory(_plant: Plant):
	# Code to check for inventory
	return true or false

## Attemps to plant in the land from the Player's inventory
func attempt_to_plant(plant: Plant):
	if is_plant_in_inventory(plant) == false:
		return
	#land_controller.spawn_plant_at(plant, ...)
	return
