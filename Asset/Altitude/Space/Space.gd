#========================
# Altitude: Space
#========================

extends Node2D

# Exported variables
export (Resource) var Star
export var star_speed = 150
export var star_last = 10
export var star_interval = 0.5

export (Resource) var Planet
export var planet_speed = 150
export var planet_last = 10
export var planet_interval = 5

# Variables
var spawn_y_min = 0
var spawn_y_max = 0
onready var rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var Spawn = $Spawn
onready var SpawnTop = $Spawn/Top
onready var SpawnBottom = $Spawn/Bottom
onready var PlanetSpawn = $Spawn/Planet
onready var StarSpawn = $Spawn/Star
onready var StarSpawnTimer = $Timer/Star
onready var PlanetSpawnTimer = $Timer/Planet

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	spawn_y_max = SpawnTop.position.y
	spawn_y_min = SpawnBottom.position.y
	PlanetSpawnTimer.wait_time = planet_interval
	PlanetSpawnTimer.start()
	StarSpawnTimer.wait_time = star_interval
	StarSpawnTimer.start()

# Get random spawn position (between SpawnTop and SpawnBottom)
func get_random_spawn_y():
	return rng.randi_range(spawn_y_min, spawn_y_max)

# Spawn star
func _on_Star_timeout():
	var star = Star.instance()
	star.speed = star_speed
	star.last = star_last
	star.position.y = get_random_spawn_y()
	StarSpawn.add_child(star)

# Spawn planet
func _on_Planet_timeout():
	var planet = Planet.instance()
	planet.speed = planet_speed
	planet.last = planet_last
	planet.position.y = get_random_spawn_y()
	PlanetSpawn.add_child(planet)
