extends PlayerCameraTypeController

# Vector2 means center of the screen
var current_touch_position = Vector2.ZERO

# Camera's viewport
var viewport: Viewport

# Screen position ratio the mouse can start moving
const minimum_ratio = 0.5
# Deadzone ratio to avoid zero division in the calculations
const deadzone = 0.0001
	
# Maximum camera velocity in metters/second
const max_camera_velocity: float = 15.0

func _on_activated():
	viewport = player_camera.get_viewport()
	pass

func _camera_process(delta: float):
	# Stop if the mouse out of viewport's bounds
	if not is_mouse_in_bounds():
		return
	
	var mouse_position_ratio = get_mouse_position_ratio()
	var camera_step = Vector2.ZERO
	
	# Deadzone ratio to avoid zero division in the calculations
	if mouse_position_ratio.abs().x < deadzone and mouse_position_ratio.abs().y < deadzone:
		return
	
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
	var abs_ratio = mouse_position_ratio.abs()
	if abs_ratio.x > deadzone:
		camera_step.x -= minimum_ratio * (mouse_position_ratio.x / abs_ratio.x)
	else:
		camera_step.x = 0.0

	if abs_ratio.y > deadzone:
		camera_step.y -= minimum_ratio * (mouse_position_ratio.y / abs_ratio.y)
	else:
		camera_step.y = 0.0

	# If absolute direction is between 1.0 and minimum ratio, then normalize between 1.0 and 0.0.
	camera_step /= Vector2(1.0 - minimum_ratio, 1.0 - minimum_ratio)
	
	player_camera.position += Vector3(-camera_step.x, 0, camera_step.y) * delta * max_camera_velocity
	


## Returns the mouse position clamped to the bounds of the viewport.
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

## Returns true if the mouse is in the viewport bounds.
func is_mouse_in_bounds() -> bool:
	return get_mouse_position_in_bounds() == viewport.get_mouse_position()
