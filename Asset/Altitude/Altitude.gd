#========================
# Altitude Manager
#========================

extends Node2D

# Enums
enum {ASIA=1,CAVE=2,STREET=3,SKY=4,SPACE=5}

# Exported variables
export var level = STREET # height level, see enum
export var height = 0 # current y corridinate (up is positive)
export var gap = 3000 # gap between two height levels
export var duration = 1.5 # tween duration in seconds
export var difficulty_decrease = 1.5

# Variables
var changing = false # during a tween?
var new_level = STREET # altutide level to change to

# Nodes
onready var timer = $Timer
onready var tween = Tween.new()
onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time
func _ready():
	add_child(tween)
	height = position.y
	global.altitude = self # set global variable
	timer.one_shot = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	height = position.y

# Change altitude
func change(to_level:int):
	if to_level < ASIA or to_level > SPACE:
		return
	if to_level != level:
		var from = global_position
		var to = Vector2(from.x, from.y + (to_level - level) * gap)
		tween.interpolate_property(self, "position", from, to, duration)
		tween.start()
		changing = true
		new_level = to_level
		global.spawner.disabled = true
		global.spawner.clear()
		timer.wait_time = duration
		timer.start()

# Fake 'callback' function of the tween
# TODO: use tween callback
func _on_Timer_timeout():
	changing = false
	level = new_level
	global.spawner.disabled = false
	if global.spawner.difficulty - difficulty_decrease > 0:
		global.spawner.difficulty -= difficulty_decrease
	else:
		global.spawner.difficulty = 0
