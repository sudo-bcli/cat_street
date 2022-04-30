#========================
# Space/Planet
#========================

extends Node2D

# Exported variables
export var speed = 150 # how fast will this node move
export var last = 10 # how long will this node live (sec)

# Nodes
onready var PlanetTimer = $Timer

# Called when the node enters the scene tree for the first time
func _ready():
	PlanetTimer.wait_time = last
	PlanetTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta

# Remove this node from node tree and memory
func _on_Timer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()
