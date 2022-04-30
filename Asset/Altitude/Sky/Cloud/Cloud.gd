#========================
# Sky/Cloud
#========================

extends Node2D

# Exported variables
export var speed = 150 # how fast will this node move
export var last = 10 # how long will this node live (sec)

# Nodes
onready var clouds = [$Cloud1, $Cloud2] # cloud types
onready var death_timer = $DeathTimer # self-destruct timer
onready var global = get_node("/root/Global") # random number generator

# Called when the node enters the scene tree for the first time
func _ready():
	for cloud in clouds:  # hide all cloud sprites
		cloud.visible = false
	var id = global.rng.randi_range(0,clouds.size()-1) # randomly show one sprite
	clouds[id].visible = true
	global.start_timer(death_timer, last)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	self.position.x -= speed * delta

# Remove from node tree and memory
func _on_Timer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()
