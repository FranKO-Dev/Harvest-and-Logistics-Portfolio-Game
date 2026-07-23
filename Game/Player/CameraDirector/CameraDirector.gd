class_name CameraDirector extends Node

## Used to read properties from the Player.
@export var player: Player
## PlayerCamera is normally a child of CameraDirector.
@export var player_camera: PlayerCamera

# Used to read properties from Player.tool_mode_manager.
var tool_mode_manager: ToolModeManager

# Used to prevent multiple deferred updates.
var update_pending := false

# Called when the Node is "ready".
func _ready() -> void:
	_assert()
	_setup()

# Validates arguments before setting up the Node.
func _assert():
	assert(player, "<player> must be set.")
	assert(player_camera, "<player_camera> must be set.")
	assert(player.tool_mode_manager, "<player> must have a tool_mode_manager property set.")

# Setups variables, events the Node needs to work.
func _setup():
	tool_mode_manager = player.tool_mode_manager
	var trigger_update_without_args  = trigger_update.unbind(1)
	# Conneting updates
	tool_mode_manager.tool_mode_switched.connect(trigger_update_without_args)
	tool_mode_manager.activated.connect(trigger_update_without_args)
	tool_mode_manager.deactivated.connect(trigger_update_without_args)
	# First update
	trigger_update()

# Updates the camera type using the current scene state snapshot.
func _update_camera_type():
	# Setting defalt camera type if no tool is active.
	if tool_mode_manager.current_tool_mode and not tool_mode_manager.current_tool_mode.is_active:
		player_camera.camera_type = PlayerCamera.CameraType.DRAG
		return
	
	var tool_mode_name = tool_mode_manager.current_tool_mode_name
	match tool_mode_name:
		"PlantingTool", "HarvestingTool":
			player_camera.camera_type = PlayerCamera.CameraType.FOLLOW_MOUSE
		_:
			player_camera.camera_type = PlayerCamera.CameraType.DRAG
	pass

# Schedules a camera update after the current execution finishes.
# Multiple calls during the same frame are combined into a single update.
func trigger_update():
	if update_pending:
		return
	
	update_pending = true
	_deferred_update.call_deferred()
	pass

# Executes the queued camera update using the latest scene state.
# This ensures the camera reads the final state after all related changes are applied.
func _deferred_update():
	update_pending = false
	_update_camera_type()
