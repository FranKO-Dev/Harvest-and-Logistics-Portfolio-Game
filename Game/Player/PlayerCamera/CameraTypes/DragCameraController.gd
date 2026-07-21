extends PlayerCameraTypeController

## Used to convert dragging into world space
const drag_amplitude: float = 0.025


## Called when unhandled_input occurs in PlayerCamera.
func _camera_unhandled_input(event: InputEvent):
	if event is InputEventScreenDrag:
		player_camera.position = player_camera.position + Vector3(event.relative.x, 0, event.relative.y) * drag_amplitude
	
