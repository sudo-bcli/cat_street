#========================
# Asia/Temple
#========================

extends Node2D

# Exported variables
export var speed = 150 # how fast will temple move
export var last = 10 # how long will temple last after spawning, in seconds

# Variables
onready var rng = RandomNumberGenerator.new() # random number generator

# Nodes
onready var Doors = [$Door/Left, $Door/Right]
onready var Lantern = $Lantern
onready var DeathTimer = $DeathTimer

# Called when the node enters the scene tree for the first time
func _ready():
	rng.randomize()
	for Door in Doors: # hide all doors
		Door.visible = false
	random_door()
	random_lantern()
	DeathTimer.wait_time = last
	DeathTimer.start()

# Randomly show left/right, or none of them
func random_door():
	var id = rng.randi_range(0, Doors.size())
	if(id < Doors.size()):
		Doors[id].visible = true
		
# Randomly show/hide all lanterns at once
func random_lantern():
	var flag = rng.randi_range(0, 1)
	if flag == 1:
		Lantern.visible = true
	else:
		Lantern.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta

# Remove this node from tree and memory
func _on_Timer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()
