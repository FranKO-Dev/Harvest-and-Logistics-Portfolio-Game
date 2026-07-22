@abstract class_name LandTool extends ToolModeClass


## Player and its properties
var player: Player
var player_camera: PlayerCamera

# A player_camera must be assigned in Player.tscn
var viewport: Viewport


## Raycast used to detect lands
@onready var land_raycast = RayCast3D.new()

const raycast_depth: float = 10000.0

const lands_collision_mask: int = 2
const lands_group = "lands"


# Called when the Node is "ready".
func _ready() -> void:
	_assert()
	_setup()


# Validates arguments before setting up the Node.
func _assert():
	var parent = get_parent()
	assert(parent is ToolModeManager,name + " must be parented to a ToolModeManager")
	assert(parent.player,parent.name + "a <player> property must be set")
	assert(parent.player.player_camera,parent.player.name + "a <player_camera> property must be set")


# Setups variables, events the Node needs to work.
func _setup():
	# Variables setup
	player = get_parent().player
	player_camera = player.player_camera
	viewport = player_camera.get_viewport()
	
	# Raycast setup
	land_raycast.collide_with_areas = true
	land_raycast.collide_with_bodies = false
	
	land_raycast.collision_mask = 0
	land_raycast.set_collision_mask_value(lands_collision_mask, true)
	
	land_raycast.enabled = false
	add_child(land_raycast)
	
	# Input processing
	set_process_unhandled_input(false)



# Called when tool is activated, used to handle the tool.
func _on_activated():
	# Enable land detection while this tool is active
	if land_raycast and land_raycast.is_node_ready():
		land_raycast.enabled = true
		set_process_unhandled_input(true)
	



# Called when the tool is deactivated, used to handle the tool.
func _on_deactivated():
	# Disable land detection while this tool is inactive
	if land_raycast and land_raycast.is_node_ready():
		land_raycast.enabled = false
		set_process_unhandled_input(false)
	



# Attempts to pick a land from a screen position
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
		_on_land_selected(collider)
	pass



# Called when a valid land is selected.
# Subclasses override this to define their action.
func _on_land_selected(_land: Node3D):
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
