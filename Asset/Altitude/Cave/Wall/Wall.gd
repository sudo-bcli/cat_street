#========================
# Cave/Wall
#========================

extends Node2D

enum {TOP, BOTTOM}

# Exported Variables
export var speed = 150 # how fast will this node move
export var last = 15 # how long will this node last
export var type = TOP # position of the wall

# Nodes
onready var DeathTimer = $DeathTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == BOTTOM: # flip wall if at bottom
		self.scale.y = -1
	DeathTimer.wait_time = last # start timer
	DeathTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta # frame interval may vary, so here try to multiple speed with delta to make animation smoother

# Remove this node from node tree and memory
func _on_DeathTimer_timeout():
	self.get_parent().remove_child(self) # remove this node from node tree, now it's an orphan node
	self.queue_free() # remove this node from memory
