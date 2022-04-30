#========================
# Global Script
# ----------------
# Auto loaded
# ex: 	To get health of player from any node, instead of using get_node("/relative/path/to/Player").health, 
#		we can now use $Global.player.health 
#========================

extends Node

# Nodes
var player
var camera
var spawner
var altitude
var title
var console
var audio
var hud
var rng = RandomNumberGenerator.new() # random number generator

# Called when the node enters the scene tree for the first time
func _ready():
	rng.randomize()

# Reset timer
func start_timer (timer, interval):
	timer.stop()
	timer.wait_time = interval
	timer.start()

# Reset timer with given range
func start_timer_rand (timer, interval_min, interval_max):
	timer.stop()
	var wait_time = rng.randf_range(interval_min, interval_max)
	timer.wait_time = wait_time
	timer.start()

# Get random float
func rand_float (from, to):
	if from <= to:
		return rng.randf_range(from,to)
	else:
		return rng.randf_range(to,from)

# Get random integer
func rand_int (from, to):
	if from <= to:
		return rng.randi_range(from,to)
	else:
		return rng.randi_range(to,from)
