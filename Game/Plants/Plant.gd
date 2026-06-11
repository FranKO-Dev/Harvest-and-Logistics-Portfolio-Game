class_name Plant extends Resource

@export var plant_name: String = "plant-name"
@export var plant_icon: Texture2D

# Each defined plant stage must have a scene to show it
@export var plant_stages: Array[PackedScene]
# Price the plant will be sold
@export var price: int = 1
# Growing time required to advance to the next stage.
@export var growth_time: int = 15
