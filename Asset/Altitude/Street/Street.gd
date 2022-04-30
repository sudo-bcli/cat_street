#========================
# Street
#========================

extends Node2D

# Exported varaibles
# Floor
export (Resource) var floor_scene # floor brick instance scene
export var floor_speed:int = 150 # how fast each floor brick moves
export var floor_last:int = 10 # how long each floor brick will last in seconds
export var floor_interval:float = 1.65 # floor brick spawn interval in seconds

# Building
export (Resource) var building_scene # building instance scene
export var building_speed = 150 # how fast each buildilng moves
export var building_last = 15 # how long each building will last in seconds
export var building_interval = 6.5 # building spawn interval in seconds

# Variables
var rng = RandomNumberGenerator.new() # Create random number generator

# Nodes
onready var FloorSpawn = $FloorSpawn # floor spawn node
onready var BuildingSpawn = $BuildingSpawn # building spawn node
onready var FloorSpawnTimer = $FloorSpawnTimer # floor spawn timer
onready var BuildingSpawnTimer = $BuildingSpawnTimer # buildilng spawn timer

# Called when the node enters the scene tree for the first time
func _ready():
	FloorSpawnTimer.wait_time = floor_interval
	FloorSpawnTimer.start()
	BuildingSpawnTimer.wait_time = building_interval
	BuildingSpawnTimer.start()
	rng.randomize()

# Spawn a floor brick
func _on_FloorSpawnTimer_timeout():
	var brick = floor_scene.instance() # floor is a keyword (?)
	brick.speed = floor_speed # check corresponding scene for more detail
	brick.last = floor_last
	FloorSpawn.add_child(brick) # attach created instance to spawn node

# Spawn a single building
func _on_BuildingSpawnTimer_timeout():
	var building = building_scene.instance()
	building.speed = building_speed # check corresponding scene for more detail
	building.last = building_last
	BuildingSpawn.add_child(building)
