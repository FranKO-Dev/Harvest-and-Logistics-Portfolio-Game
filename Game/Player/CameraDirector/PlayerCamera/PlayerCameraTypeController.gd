@abstract class_name PlayerCameraTypeController extends RefCounted

## Current state
var isActive: bool = false

## Emitted when the isActive state changes
signal isActiveChanged

var player_camera: PlayerCamera

## Always run this super-class method as super() in the sub-class in case
## you want to overwrite this method.
func _init(_player_camera: PlayerCamera) -> void:
	player_camera = _player_camera
	

## Called when unhandled_input occurs in PlayerCamera.
func _camera_unhandled_input(_event: InputEvent):
	pass

## Called when _process occurs in PlayerCamera.
func _camera_process(_delta: float):
	pass

## Base method for activating the mode.
## Always run this super-class method as super.activate() in the sub-class 
## to check if the tool mode can be activated or not.
## This functions returns true if the activation was successfull.
func activate() -> bool:
	if (isActive):
		return false
	# Calling sub-class owned callback function
	isActive = true
	_on_activated()
	isActiveChanged.emit()
	return true

## Called when tool is activated, used to handle the tool.
func _on_activated():
	pass

## Base method for activating the mode.
## Always run this super-class method as super.deativate() in the sub-class
## to check if the tool mode can be deactivated or not.
## This functions returns true if the deactivation was successfull.
func deactivate() -> bool:
	if isActive == true:
		# Calling sub-class owned callback function
		isActive = false
		_on_deactivated()
		isActiveChanged.emit()
		return true
	return false

## Called when is deactivated, used to handle the tool.
func _on_deactivated():
	pass
