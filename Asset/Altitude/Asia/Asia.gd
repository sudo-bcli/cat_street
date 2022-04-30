#========================
# Altitude: Asia
# It's the other side of globe, thus everything is upside down
#========================

extends Node2D

# Exported variables
export (Resource) var Floor
export var floor_speed = 150
export var floor_last = 10
export var floor_interval = 1.65

export (Resource) var Temple
export var temple_speed = 150
export var temple_last = 15
export var temple_interval = 10

# Nodes
onready var TempleSpawn = $TempleSpawn
onready var FloorSpawn = $FloorSpawn
onready var TempleSpawnTimer = $Timer/Temple
onready var FloorSpawnTimer = $Timer/Floor

# Called when the node enters the scene tree for the first time.
func _ready():
	TempleSpawnTimer.wait_time = temple_interval
	TempleSpawnTimer.start()
	FloorSpawnTimer.wait_time = floor_interval
	FloorSpawnTimer.start()

# Spawn temple
func _on_Temple_timeout():
	var temple = Temple.instance()
	temple.speed = temple_speed
	temple.last = temple_last
	TempleSpawn.add_child(temple)

# Spawn floor
func _on_Floor_timeout():
	var brick = Floor.instance()
	brick.speed = floor_speed
	brick.last = floor_last
	FloorSpawn.add_child(brick)
