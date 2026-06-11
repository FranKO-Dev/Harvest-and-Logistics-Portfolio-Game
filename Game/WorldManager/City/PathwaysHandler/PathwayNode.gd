class_name PathwayNode extends Node

"""
	PathwayNode (node graph data structure):
		This node is used for pathfinding and road generation.
		It is intended to be used with grid-based systems or any system
		that respects grid-like boundaries on a 3D plane. For this reason,
		each PathwayNode can have up to four neighbors: up, right, down,
		and left.
		
		PathwaysHandler defines whether neighbors are unidirectional or
		bidirectional.
"""

## 3D position the Node is located in World-space.
var position: Vector3 = Vector3.ZERO

## Pathway node neighbors at the four sides. PathwaysHandler will define
## unidirectional or bidirectional neighbors.
var neighbors: Dictionary[String, PathwayNode] = {
	"up" : null,
	"right" : null,
	"down": null,
	"left": null
}

## When rendering roads, this boolean will determine if the road generation will skip
## the rendering of the intersection on this PathwayNode.
var ignore_road_intersection: bool = false

# Called when the object is instantiated.
func _init(start_position: Vector3,
			up: PathwayNode = null, right: PathwayNode = null,
			down: PathwayNode = null, left: PathwayNode = null) -> void:
	# Assigning values
	position = start_position
	if up != null:
		neighbors["up"] = up
	if right != null:
		neighbors["right"] = right
	if down != null:
		neighbors["down"] = down
	if left != null:
		neighbors["left"] = left
	
