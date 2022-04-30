#========================
# Altitude: Cave
#========================

extends Node2D

# Exported variables
export (Resource) var Wall
export var wall_speed = 150
export var wall_last = 20
export var wall_interval = 6.8

export (Resource) var StoneColumn
export var column_speed = 150
export var column_last = 10
export var column_interval_min = 0.2
export var column_interval_max = 1
export var column_size_min = 0.6
export var column_size_max = 1

# Variables
onready var rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var TopWallSpawn = $Spawn/TopWall
onready var BottomWallSpawn = $Spawn/BottomWall
onready var StalactiteSpawn = $Spawn/Stalactite
onready var StalagmiteSpawn = $Spawn/Stalagmite
onready var WallSpawnTimer = $Timer/Wall
onready var StalactiteSpawnTimer = $Timer/Stalactite
onready var StalagmiteSpawnTimer = $Timer/Stalagmite

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	spawn_walls()
	WallSpawnTimer.wait_time = wall_interval
	WallSpawnTimer.start()
	rand_column_spawn_interval(StalactiteSpawnTimer)
	rand_column_spawn_interval(StalagmiteSpawnTimer)

# Randomize stone column interval
func rand_column_spawn_interval(timer):
	timer.stop()
	timer.wait_time = rng.randf_range(column_interval_min, column_interval_max)
	timer.start()

# For cave, delay spawned walls look ugly so
# put it into a function so we can fast spawn walls on ready, don't have to wait for the timer
func spawn_walls():
	var top_wall = Wall.instance()
	top_wall.speed = wall_speed
	top_wall.last = wall_last
	top_wall.type = top_wall.TOP
	TopWallSpawn.add_child(top_wall)
	var bottom_wall = Wall.instance()
	bottom_wall.speed = wall_speed
	bottom_wall.last = wall_last
	bottom_wall.type = bottom_wall.BOTTOM
	BottomWallSpawn.add_child(bottom_wall)

# Spawn both top and bottom walls
func _on_Wall_timeout():
	spawn_walls()

# Spawn stalagmite
func _on_Stalagmite_timeout():
	var column = StoneColumn.instance()
	column.speed = column_speed
	column.last = column_last
	column.type = column.STALAGMITE
	StalagmiteSpawn.add_child(column)
	rand_column_spawn_interval(StalagmiteSpawnTimer)

# Spawn stalactitie
func _on_Stalactite_timeout():
	var column = StoneColumn.instance()
	column.speed = column_speed
	column.last = column_last
	column.type = column.STALACTITE
	StalactiteSpawn.add_child(column)
	rand_column_spawn_interval(StalactiteSpawnTimer)
