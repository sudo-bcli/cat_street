#========================
# Altitude: Sky
# between street and space
#========================

extends Node2D

# Exported variables
export (Resource) var Cloud
export var cloud_speed = 150
export var cloud_last = 10
export var cloud_interval = 3

# Variables
var spawn_y_min = 0
var spawn_y_max = 0
onready var Rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var Spawn = $Spawn
onready var SpawnTop = $Spawn/Top
onready var SpawnBottom = $Spawn/Bottom
onready var CloudSpawnTimer = $Timer/Cloud

# Called when the node enters the scene tree for the first time.
func _ready():
	Rng.randomize()
	spawn_y_max = SpawnTop.position.y
	spawn_y_min = SpawnBottom.position.y
	CloudSpawnTimer.wait_time = cloud_interval
	CloudSpawnTimer.start()

# Get random spawn position (between SpawnTop and SpawnBottom)
func get_random_spawn_y():
	return Rng.randi_range(spawn_y_min, spawn_y_max)

# Spawn cloud
func _on_Cloud_timeout():
	var cloud = Cloud.instance()
	cloud.speed = cloud_speed
	cloud.last = cloud_last
	cloud.position.y = get_random_spawn_y()
	Spawn.add_child(cloud)
