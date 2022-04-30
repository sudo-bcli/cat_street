#========================
# Cave/Stone Column
#========================

extends Node2D

# Enum
enum {STALACTITE,STALAGMITE}

# Exported Variables
export var speed = 150 # how fast will this node move
export var last = 10 # how long will this node last
export var size_min = 0.2 # minimal size
export var size_max = 1 # maximum size
export var type = STALACTITE # stone column type

# Variables
var rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var Stalactites = [$Stalactite1, $Stalactite2]
onready var Stalagmites = [$Stalagmite1, $Stalagmite2]
onready var DeathTimer = $DeathTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	random_stone_column()
	DeathTimer.wait_time = last # start timer
	DeathTimer.start()

# Show random column in one column type, then pick a random size within range of size_min and size_max
func random_stone_column():
	for Stalactite in Stalactites: # hide all columns
		Stalactite.visible = false
	for Stalagmite in Stalagmites:
		Stalagmite.visible = false	
	var Columns
	if type == STALACTITE:
		Columns = Stalactites
	elif type == STALAGMITE:
		Columns = Stalagmites
	else:
		return
	rng.randomize()
	var id = rng.randi_range(0, Columns.size()-1)
	Columns[id].visible = true
	var rand_size = rng.randf_range(size_min, size_max) # set random size
	self.scale = Vector2(rand_size, rand_size)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta # frame interval may vary, so here try to multiple speed with delta to make animation smoother

# Remove this node from node tree and memory
func _on_DeathTimer_timeout():
	self.get_parent().remove_child(self) # remove this node from node tree, now it's an orphan node
	self.queue_free() # remove this node from memory
