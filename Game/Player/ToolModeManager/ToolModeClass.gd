@abstract class_name ToolModeClass extends Node

# -----------------------------------------------------------------------------
#	ToolModeClass - BaseClass
#
# Base class for all tool modes managed by ToolModeManager.
#
# Lifecycle ownership WARNING:
#	ToolModeManager is the sole authority responsible for activating and
#	deactivating tool modes. ToolModeClass instances should never manage the
#	activation state of other tool modes.
#
# Subclass rules:
#   1. Override _on_activated() and _on_deactivated() to implement tool
#      specific behavior.
#
#   2. If activate() or deactivate() are overridden, always call
#      super.activate() or super.deactivate() first.
#
#   3. Never modify isActive directly outside of activate() and deactivate().
#
#   4. Never activate or deactivate other tool modes from within a tool mode.
#      ToolModeManager is responsible for all tool transitions.
# -----------------------------------------------------------------------------

## Current state of the mode
var isActive: bool = false

## Emitted when the isActive state changes
signal isActiveChanged

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

## Called when the tool is deactivated, used to handle the tool.
func _on_deactivated():
	pass
