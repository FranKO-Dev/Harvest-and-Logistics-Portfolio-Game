extends Control

## Set by a parent scene. ControlPanel ToolModeNavbar will read from.
@export var control_panel: Control
## Player to handle tools from.
var player: Player
## ToolModeManager to handle tools.
var tool_mode_manager: ToolModeManager

## Container that holds all tool mode buttons.
@export var tool_buttons_container: HBoxContainer
## Container that holds the close button.
@export var close_button_container: Control

## Metadata key for tool buttons.
const tool_mode_name_meta = &"tool_mode_name"
## Actio name that cancels the current tool.
const cancel_tool_action = &"cancel_tool"

# Called when the Node is "ready".
func _ready() -> void:
	_assert()
	_setup()
	pass

# Setups needed variables, and events for the Node to work.
func _setup():
	player = control_panel.player
	tool_mode_manager = player.tool_mode_manager
	# Making navbar react to signals.
	tool_mode_manager.activated.connect(_on_tool_activated)
	tool_mode_manager.deactivated.connect(_on_tool_deactivated)
	# Updating navbar state.
	if tool_mode_manager.current_tool_mode:
		if tool_mode_manager.current_tool_mode.is_active:
			_on_tool_activated(tool_mode_manager.current_tool_mode_name)
	# Setting up tool buttons from tool_buttons_container.
	_setup_tool_buttons()
	_setup_close_button()
	

# Setups tool buttons from tool_buttons_container.
func _setup_tool_buttons():
	var tool_button_numeric_key: int = 1
	for tool_button in tool_buttons_container.get_children():
		_with_tool_toggling(tool_button)
		_with_shortcut(tool_button, create_numeric_key_event(tool_button_numeric_key))
		tool_button_numeric_key += 1
	

## Setups close button, adds mouse button 2 to cancel tools.
func _setup_close_button():
	var action_event = InputEventAction.new()
	action_event.action = cancel_tool_action
	_with_shortcut(close_button_container.close_button, action_event)
	pass

## Adds tool toggling to a tool button node.
func _with_tool_toggling(tool_button: BaseButton) -> BaseButton:
	var tool_mode_name = tool_button.get_meta(tool_mode_name_meta)
	
	# Returning the tool_button no matter what.
	if not tool_mode_name:
		return tool_button
	
	## Switches the tool mode to the fetched tool_mode_name.
	var set_tool_mode = func():
		tool_mode_manager.switch_tool_mode(tool_mode_name)
	tool_button.pressed.connect(set_tool_mode)
	
	return tool_button

## Assigns a key shortcut using tool_button_index.
func _with_shortcut(tool_button: BaseButton, event: InputEvent) -> BaseButton:
	# Creating shortcut
	var shortcut = tool_button.shortcut if tool_button.shortcut else Shortcut.new()
	# Creating key event
	shortcut.events.append(event)
	# Assigning shortcut
	tool_button.shortcut = shortcut
	
	var key_label: Label = tool_button.get_node_or_null("KeyLabel")
	if key_label:
		if event is InputEventKey:
			key_label.text = OS.get_keycode_string(event.keycode)
	return tool_button

## Creates a new key event using a numerical key index as argument.
func create_numeric_key_event(numerical_key: int) -> InputEventKey:
	var key_event = InputEventKey.new()
	key_event.keycode = OS.find_keycode_from_string(var_to_str(numerical_key))
	return key_event

## Called when <close_button_container>.close_button_pressed signal is emitted.
func _on_close_button_pressed() -> void:
	tool_mode_manager.deactivate_current_tool_mode()
	

func _on_tool_activated(_tool_mode_name):
	close_button_container.show_button()
	pass

func _on_tool_deactivated(_tool_mode_name):
	close_button_container.hide_button()
	pass

# Validates variables before setup.
func _assert():
	assert(control_panel != null, "A <control_panel> must be assigned.")
	assert(control_panel.get("player"), "<control_panel> must have a <player> assigned.")
	assert(control_panel.player.tool_mode_manager, "player nust have a tool_mode_manager assigned.")
	assert(tool_buttons_container != null, "A <tool_buttons_container> must be assigned.")
	assert(close_button_container != null, "A <close_button_container> must be assigned.")
