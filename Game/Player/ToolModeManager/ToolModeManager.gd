class_name ToolModeManager extends Node
# -----------------------------------------------------------------------------
#	ToolModeManager
#
#	This manager is the single authority responsible for activating and
#	deactivating tool modes.
#
#	- Invariant:
#	Only one ToolMode may be active at any given time.
#
#	- Why this exists:
#	If multiple tool modes become active simultaneously, game behavior becomes
#	unpredictable and difficult to debug. ToolModeManager guarantees that tool
#	mode transitions happen safely and consistently.
#
#	WARNING:
#	Activating or deactivating tool modes directly bypasses the manager and may
#	leave multiple tool modes active at the same time, resulting in undefined
#	behavior.
#
#	Rules:
#	1.	Never call activate() or deactivate() on a ToolMode from outside
#		ToolModeManager.
#
#	2.	Accessing tool properties and calling tool-specific methods is allowed.
#
#	3.	All tool mode activation, deactivation, and switching must go through
#		ToolModeManager methods such as switch_tool_mode().
# -----------------------------------------------------------------------------

## Set by Player.tscn or a parent scene. Used to read properties from the Player. 
@export var player: Player

# Tool mode currently handled
var current_tool_mode: ToolMode
var current_tool_mode_name:
	get():
		return tool_modes.find_key(current_tool_mode)

# Tool signals
signal tool_mode_switched(new_tool_mode_name: String)
signal activated(tool_mode_name: String)
signal deactivated(tool_mode_name: String)

# Tool modes variable declaration, make sure it assing a new tool_mode set once.
@onready var tool_modes: Dictionary[String, ToolMode] = {
	"PlantingTool" : $PlantingTool,
	"HarvestingTool": $HarvestingTool,
}


# Setting up ToolModeManager
func _ready() -> void:
	_setup_tool_signals()
	

# Connects the signals from tool_modes and unifies them on on_activate and on_deactivate
func _setup_tool_signals():
	for tool_mode_name in tool_modes.keys():
		var tool_mode: ToolMode = tool_modes[tool_mode_name]
		# Emtting on_activate or on_deactivate whether if the tool_mode is_active or not
		tool_mode.is_active_changed.connect(func():
			match tool_mode.is_active:
				true:
					activated.emit(tool_mode_name)
				false:
					deactivated.emit(tool_mode_name)
			)
	pass

## Returns true of a tool name is registered in tool_modes
func tool_mode_exists(tool_mode_name: String) -> bool:
	return tool_modes.keys().has(tool_mode_name)

## Returns a ToolMode registered in tool_modes safely. In case not found, it returns null.
func get_tool_mode(tool_mode_name: String) -> ToolMode:
	if tool_mode_exists(tool_mode_name) == false:
		push_warning("Tool Mode '%s' doesn't exist in tool_modes. It must be registered."% tool_mode_name)
		return null
	return tool_modes[tool_mode_name]

## Returns all the registered tool names in tool_modes.
func get_tool_mode_names() -> Array[String]:
	return tool_modes.keys().duplicate()

## Switches the current tool mode to another tool_mode then activates it.
## In case it's the same tool_mode as the current one, it will get activated safely.
func switch_tool_mode(tool_mode_name: String):
	# Getting new tool mode
	var new_tool_mode: ToolMode = get_tool_mode(tool_mode_name)
	# In case not found
	if not new_tool_mode:
		return
	# In case is the same tool mode, then activate if deactivated.
	if current_tool_mode == new_tool_mode:
		if current_tool_mode:
			current_tool_mode.activate()
	else:
		if current_tool_mode:
			current_tool_mode.deactivate()
		current_tool_mode = new_tool_mode
		current_tool_mode.activate()
		# Emitting tool_mode_switched signal
		tool_mode_switched.emit(tool_mode_name)
	

## Returns true if the current_tool_mode has been deactivated sucessfully or there is no tool_mode.
## Otherwise if it was already deactivated returns false.
func deactivate_current_tool_mode() -> bool:
	if current_tool_mode:
		return current_tool_mode.deactivate()
	return true
