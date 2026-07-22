class_name PlantingTool extends LandTool

## Plant seed to attempt to plant
@export var plant_seed: PlantSeed

# Called when a valid land is selected.
func _on_land_selected(_land: Node3D):
	_plant_on_land(_land)
	

## Attemps to plant in the plant plant_seed using player's inventory
func _plant_on_land(land: Node3D):
	if plant_seed == null:
		return
	var result = player.plant_seed_on_land(land, plant_seed)
	return result
	
