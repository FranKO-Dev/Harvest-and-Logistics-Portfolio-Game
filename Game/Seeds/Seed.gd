class_name Seed extends RefCounted

# Seed display data
@export var seed_name: String = "seed-name"
@export var seed_icon: Texture2D

# Plant that will be used to grow the seed
@export var plant: Plant
# Price the seed costs
@export var price: int = 1
