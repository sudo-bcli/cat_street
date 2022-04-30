#========================
# Game Title
#========================

extends Control

# Exported Variables
export var initial_volume = -50 # db
export var volume_increase_speed = 0.05

# Nodes
onready var global = get_node("/root/Global")
onready var target_volume = global.audio.volume

# Called when the node enters the scene tree for the first time
func _ready():
	global.title = self # set global variable
	global.audio.volume = initial_volume
	global.audio.play(global.audio.DRUM)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	if global.audio.volume < target_volume:
		global.audio.volume += volume_increase_speed * delta

# Called when there is an input event
func _input(event):
	if event is InputEventKey:
		if event.pressed: # when any key is pressed
			if (!Input.is_action_pressed("console")): # ` does not count as 'any key', this allow user to toggle debug console in title mode
				global.player.disabled = false # enable player control
				global.spawner.disabled = false # enable enemry spawner
				global.hud.state = global.hud.GAME
				global.hud.visible = true
				#global.audio.play(global.audio.STREET) # play street music
				self.get_parent().remove_child(self) # remove Title node since it's no longer needed
				self.queue_free() # remove Title node from memory
