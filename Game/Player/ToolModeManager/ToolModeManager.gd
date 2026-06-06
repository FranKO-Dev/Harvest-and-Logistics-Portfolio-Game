class_name ToolModeManager extends Node

## Tool mode currently handled
var current_tool_mode: ToolModeClass
# Tool modes declaration
var tool_modes: Dictionary[String, ToolModeClass] = {
	"PlantingTool" : PlantingTool.new(),
}
