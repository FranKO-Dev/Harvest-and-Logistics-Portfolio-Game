extends PlayerCameraTypeController

# Vector2 means center of the screen
var current_touch_position = Vector2.ZERO

# Camera's viewport
var viewport: Viewport

const minimum_ratio = 0.5

# Maximum camera velocity in metters/second
const max_camera_velocity: float = 15.0

func _on_activated():
	viewport = player_camera.get_viewport()
	pass

func _camera_process(delta: float):
	var mouse_position_ratio = get_mouse_position_ratio()
	var camera_step = Vector2.ZERO
	
	# Handling X
	if mouse_position_ratio.x < 0.0:
		camera_step.x = minf(mouse_position_ratio.x, -minimum_ratio)
	else:
		camera_step.x =  maxf(mouse_position_ratio.x, minimum_ratio)
	
	# Handling Y
	if mouse_position_ratio.y < 0.0:
		camera_step.y = minf(mouse_position_ratio.y, -minimum_ratio)
	else:
		camera_step.y =  maxf(mouse_position_ratio.y, minimum_ratio)
	
	# If absolute direction is minimum_ratio or less, then truncating to 0.0
	camera_step -= Vector2(minimum_ratio, minimum_ratio) * (mouse_position_ratio/mouse_position_ratio.abs())
	# If absolute direction is between 1.0 and minimum ratio, then normalize between 1.0 and 0.0.
	camera_step /= Vector2(1.0 - minimum_ratio, 1.0 - minimum_ratio)
	
	player_camera.position += Vector3(-camera_step.x, 0, camera_step.y) * delta * max_camera_velocity
	


## Returns the mouse position clamped to the bounds of the viewport
func get_mouse_position_in_bounds() -> Vector2:
	var viewport_size = viewport.get_visible_rect().size
	var mouse_position = viewport.get_mouse_position()
	return Vector2(
		clampf(mouse_position.x, 0, viewport_size.x), 
		clampf(mouse_position.y, 0, viewport_size.y)
	)
	

## Returns the mouse direction the camera will move. x and y values are between -1.0, to 1.0.
## x = 0.0, y = 0.0 means it's at the center of the screen.
## x = 1.0, y = 1.0 means it's at the upper right corner of the screen.
func get_mouse_position_ratio():
	var viewport_size = viewport.get_visible_rect().size
	var mouse_position = get_mouse_position_in_bounds() - viewport_size/2.0
	mouse_position /= viewport_size
	mouse_position *= 2.0
	mouse_position.y = -mouse_position.y
	return mouse_position
