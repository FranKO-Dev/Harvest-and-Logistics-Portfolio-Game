extends Resource
class_name Plant

@export var plant_name: String = "noname"
@export var plant_icon: Texture2D

# Each defined plant stage must have a scene to show it
@export var plant_stages: Array[PackedScene]
@export var cost: int = 1
