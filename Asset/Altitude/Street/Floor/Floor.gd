#========================
# Street/Floor
#========================

extends StaticBody2D

# Exported varibles
export var speed = 150 # how fast each floor brick moves
export var last = 10 # how long will each floor birck last after spawning (sec)

# Nodes
onready var DeathTimer = $DeathTimer # self destruct timer

# Called when the node enters the scene tree for the first time
func _ready():
	self.constant_linear_velocity.x = -speed # set linear speed of StaticBody, so items which fall on the floor will move with it
	DeathTimer.wait_time = last # start self destruct count down
	DeathTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta # frame interval may vary, so here we multiple delta to make animation smoother

# Remove it from node tree and memory
func _on_Timer_timeout():
	self.get_parent().remove_child(self) # remove from node tree
	self.queue_free() # remove from memory
