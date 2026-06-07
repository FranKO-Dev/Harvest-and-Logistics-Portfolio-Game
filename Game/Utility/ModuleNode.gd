class_name ModuleNode extends Node

# ModuleNode.gd
# Node that works as a module that automatically attaches
# to a parent Node.

# Setups the parent and node's name
func _init(parent: Node, mode_name: String) -> void:
	if not parent.is_inside_tree():
		await parent.tree_entered
	name = mode_name
	parent.add_child(self)
	
