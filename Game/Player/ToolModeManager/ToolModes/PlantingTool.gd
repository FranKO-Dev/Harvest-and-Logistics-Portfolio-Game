class_name PlantingTool extends ToolModeClass

## Getting player and its properties
@export var player: Player
@export var player_camera: PlayerCamera

# A player_camera must be assigned in Player.tscn
@onready var viewport: Viewport = player_camera.get_viewport()

## Plant seed to attempt to plant
@export var plant_seed: PlantSeed

## Raycast used to detect lands
@onready var land_raycast = RayCast3D.new()
const raycast_depth: float = 10000.0

const lands_collision_mask: int = 2
const lands_group = "lands"

func _ready() -> void:
	land_raycast.collide_with_areas = true
	land_raycast.collide_with_bodies = false
	
	land_raycast.collision_mask = 0
	land_raycast.set_collision_mask_value(lands_collision_mask, true)
	
	land_raycast.enabled = false
	
	add_child(land_raycast)
	set_process_unhandled_input(false)
	

# Called then tool is activated
func _on_activated():
	if land_raycast and land_raycast.is_node_ready():
		land_raycast.enabled = true
		set_process_unhandled_input(true)
	pass

# Called then tool is deactivated
func _on_deactivated():
	if land_raycast and land_raycast.is_node_ready():
		land_raycast.enabled = false
		set_process_unhandled_input(false)
	pass

## Attemps to plant in the plant plant_seed using player's inventory
func _plant_on_land(land: Node3D):
	if plant_seed == null:
		return
	var result = player.plant_seed_on_land(land, plant_seed)
	if result == OK:
		prints("Planted!", get_path())
		pass
	

func _pick_land_from_screen_position(screen_point: Vector2):
	var screen_res = viewport.get_visible_rect().size
	# If the position is out of screen bounds
	if screen_point != screen_point.clamp(Vector2.ZERO, screen_res):
		return
	
	var ray_direction: Vector3 = player_camera.project_position(screen_point, raycast_depth)
	land_raycast.global_position = player_camera.global_position
	land_raycast.force_raycast_update()
	land_raycast.target_position = ray_direction
	
	var collider: CollisionObject3D = land_raycast.get_collider()
	if collider and collider.is_in_group(lands_group):
		_plant_on_land(collider)
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Click events
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			_pick_land_from_screen_position(viewport.get_mouse_position())
	if event is InputEventScreenTouch and event.is_pressed():
		_pick_land_from_screen_position(viewport.get_mouse_position())
	
	# Drag events
	if event is InputEventScreenDrag:
		if player_camera.camera_type == PlayerCamera.CameraType.FOLLOW_MOUSE:
			_pick_land_from_screen_position(viewport.get_mouse_position())
	
