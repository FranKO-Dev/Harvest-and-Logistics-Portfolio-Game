class_name PlayerCamera extends Camera3D

enum CameraType{
	DRAG,
	FOLLOW_MOUSE,
	SCRIPTABLE,
}

## Current camera type
@export var camera_type: CameraType = CameraType.DRAG:
	set(value):
		var last = camera_type; camera_type = value
		on_camera_type_changed(last, camera_type)
		camera_type_changed.emit(value)
		
## Camera type changed signal
signal camera_type_changed(new_value: CameraType)

# Camera controllers
@onready var _drag_camera_controller = preload("res://Game/Player/CameraDirector/PlayerCamera/CameraTypes/DragCameraController.gd").new(self)
@onready var _follow_mouse_camera_controller = preload("res://Game/Player/CameraDirector/PlayerCamera/CameraTypes/FollowMouseCameraController.gd").new(self)

func _ready() -> void:
	var current_controller = _get_camera_controller(camera_type)
	if current_controller:
		current_controller.activate()
	else:
		set_camera_processes(false)

## Called when camera types changes.
func on_camera_type_changed(last_type, current_type):
	var last_controller = _get_camera_controller(last_type)
	if last_controller:
		last_controller.deactivate()
	
	var current_controller = _get_camera_controller(current_type)
	if current_controller:
		current_controller.activate()
	
	if current_type == CameraType.SCRIPTABLE or _get_camera_controller(current_type) == null:
		set_camera_processes(false)
	else:
		set_camera_processes(true)
	pass

func set_camera_processes(enable: bool):
	set_process_unhandled_input(enable)
	set_process(enable)

## Returns the camera controller from the specified camera_type
func _get_camera_controller(camera_type_value: CameraType) -> PlayerCameraTypeController:
	match camera_type_value:
		CameraType.DRAG:
			return _drag_camera_controller
		CameraType.FOLLOW_MOUSE:
			return _follow_mouse_camera_controller
		_:
			return null
	

func _unhandled_input(event: InputEvent) -> void:
	_get_camera_controller(camera_type)._camera_unhandled_input(event)
	pass

func _process(delta: float) -> void:
	_get_camera_controller(camera_type)._camera_process(delta)
	pass
