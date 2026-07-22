class_name HarvestingTool extends LandTool

# Called when a valid land is selected.
func _on_land_selected(land: Node3D):
	_harvest_land(land)

# Makes the player havest a selected land.
func _harvest_land(land: Node3D):
	var result = player.havest_seed_on_land(land)
	prints("Attempt harvesting:", result)
	pass
