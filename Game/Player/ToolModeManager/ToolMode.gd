@abstract class_name ToolMode extends Node

# -----------------------------------------------------------------------------
#	ToolMode - BaseClass
#
# Base class for all tool modes managed by ToolModeManager.
#
# Lifecycle ownership WARNING:
#	ToolModeManager is the sole authority responsible for activating and
#	deactivating tool modes. ToolMode instances should never manage the
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
var is_active: bool = false

## Emitted when the is_active state changes
signal is_active_changed

## Base method for activating the mode.
## Always run this super-class method as super.activate() in the sub-class 
## to check if the tool mode can be activated or not.
## This functions returns true if the activation was successfull.
func activate() -> bool:
	if (is_active):
		return false
	# Calling sub-class owned callback function
	is_active = true
	_on_activated()
	is_active_changed.emit()
	return true

## Called when tool is activated, used to handle the tool.
func _on_activated():
	pass

## Base method for activating the mode.
## Always run this super-class method as super.deativate() in the sub-class
## to check if the tool mode can be deactivated or not.
## This functions returns true if the deactivation was successfull.
func deactivate() -> bool:
	if is_active == true:
		# Calling sub-class owned callback function
		is_active = false
		_on_deactivated()
		is_active_changed.emit()
		return true
	return false

## Called when the tool is deactivated, used to handle the tool.
func _on_deactivated():
	pass
