class_name LandGrowingComponent extends RefCounted

# Dictionary that stores the current stage of the Land as Key
var growing: Dictionary[Node3D, int] = {}
# Plant currently growing on each land
var growing_plant: Dictionary[Node3D, Plant] = {}
# Time accumulated for each land
var growing_time: Dictionary[Node3D, float] = {}
# Dictionary of Lands that are ready for harvest
var for_harvest: Dictionary[Node3D, Plant] = {}

# Timer that handles growing for all plants in the lands
var growing_timer: Timer

## Starts the LandGrowingComponent.
func start():
	clear_all()
	start_growing_timer()
	

## Clears all the tracking data, including for_harvest.
func clear_all():
	growing.clear()
	growing_plant.clear()
	growing_time.clear()
	for_harvest.clear()
	

func start_growing_timer():
	if growing_timer:
		return
	
	growing_timer = Timer.new()
	growing_timer.wait_time = 1.0
	growing_timer.name = "GrowingTimer"
	growing_timer.autostart = true
	growing_timer.timeout.connect(_on_timer_timeout)
	
	# Using Engine.get_main_loop() instead of Node.get_tree() because
	# this class is not a Node sub-class
	Engine.get_main_loop().current_scene.add_child.call_deferred(growing_timer)
	

## Spawns a seed on a land safely, returning status codes for error checking.
## If success, the status code returned is 0 or OK.
func spawn_seed_on_land(land: Node3D, plant_seed: PlantSeed) -> Error:
	if not land.is_in_group("lands"):
		return ERR_INVALID_PARAMETER
	if plant_seed.plant == null:
		return ERR_INVALID_DATA
	if not is_land_empty(land):
		return ERR_UNAVAILABLE
	# Spawning a plant on land after checking
	spawn_plant_on_land(land, plant_seed.plant)
	return OK

## Returns true if a land has no plant in it, otherwise returns false.
func is_land_empty(land: Node3D):
	return not (growing.has(land) or for_harvest.has(land) or growing_time.has(land))

## Spawns a plant on a land, always check with is_land_empty() before running this function.
func spawn_plant_on_land(land: Node3D, plant: Plant):
	if not land or not plant:
		push_error("Land and Plant are required.")
		return
	
	if growing.has(land) or for_harvest.has(land):
		push_warning("Land is already occupied.")
		return
	
	growing[land] = 0
	growing_plant[land] = plant
	growing_time[land] = 0
	
	show_plant_stage(land, 0, plant)
	

# Runs when the growing timer gets timed out.
func _on_timer_timeout():
	# Array of grown lands
	var completed: Array[Node3D] = []
	
	for land in growing.keys():
		var plant := growing_plant[land]
		growing_time[land] += growing_timer.wait_time
		
		if growing_time[land] < plant.growth_time:
			continue
			
		growing_time[land] = 0
		growing[land] += 1
		
		var stage := growing[land]
		
		if stage >= plant.plant_stages.size():
			for_harvest[land] = plant
			# Keep showing the final stage
			show_plant_stage(land,plant.plant_stages.size() - 1, plant)
			completed.append(land)
		else:
			show_plant_stage(land,stage,plant)
	
	# Untracking grown plants
	for land in completed:
		growing.erase(land)
		growing_plant.erase(land)
		growing_time.erase(land)
	


## Clears the plant render at the land.
## Use this always before rendering another plant stage.
func clear_plant_render(land: Node3D):
	var render = land.get_node_or_null("PlantStageRenderInstance")
	if render:
		render.name = "_"
		render.queue_free()
		


## Places a plant stage on a land
func render_plant_stage(land: Node3D, stage: int, plant: Plant):
	if not land or not plant:
		push_error("Land and Plant are required.")
		return
	if stage < 0:
		push_error("Stage must be >= 0.")
		return
	if plant.plant_stages.is_empty():
		push_error("Plant has no stages.")
		return
	if stage >= plant.plant_stages.size():
		push_error(
			"Stage %s is not valid for %s." %
			[stage, plant.resource_path]
		)
		return
	
	var render = plant.plant_stages[stage].instantiate()
	render.name = "PlantStageRenderInstance"
	land.add_child(render)
	


## Shows a plant stage scene in the land
func show_plant_stage(land: Node3D, stage: int = -1, plant: Plant = null):
	clear_plant_render(land)
	if stage > -1:
		render_plant_stage(land, stage, plant)
	


## Returns if a land is ready for harvest
func is_for_harvest(land: Node3D) -> bool:
	return for_harvest.has(land)
	


## Runs after harvesting
func update_havested(land: Node3D):
	for_harvest.erase(land)
	
	growing.erase(land)
	growing_plant.erase(land)
	growing_time.erase(land)
	
	show_plant_stage(land)
	
