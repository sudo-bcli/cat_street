#========================
# Street/Building
#========================

extends Node2D

# Exported variables
export var speed = 150 # how fast each building moves
export var last = 10 # how long will this building last after spawning in second

# Variables
var rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var doors = [$Door/Left, $Door/Center, $Door/Right] # put door nodes into an array and toggle them by random index
onready var DeathTimer = $DeathTimer # when trigger, remove this building from node tree and memory

# Called when the node enters the scene tree for the first time
func _ready():
	for door in doors: # hide all doors
		door.visible = false
	random_door()
	DeathTimer.wait_time = last # remove this building after timeout
	DeathTimer.start()

# Randomly show left/center/right door, or none of them
func random_door():
	rng.randomize()
	var id = rng.randi_range(0, doors.size())
	if(id < doors.size()):
		doors[id].visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta # frame interval may vary, so here try to multiple speed with delta to make animation smoother

# Remove this node from tree and memory
func _on_Timer_timeout():
	self.get_parent().remove_child(self) # remove this node from node tree, now it's an orphan node
	self.queue_free() # remove this node from memory
