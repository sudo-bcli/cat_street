#========================
# Enemy & Item Spawner
# -----------------------
# spawn difficulty (interval deduction) is stored as an array [easy, normal, hard] 
# ex: popcat has spawn interval of 4s~7s, its difficulty array is [0,1,2]
#     then in NORMAL mode, its spawn interval becomes 4-1~7-1 = 3s~6s
#========================

extends Node2D

# Enums
enum {TOP, BOTTOM, BOTH} # popcat can appear on bottom (street), top (asia, flipped) or both (cave) 

# Variables
export var disabled = true
export var has_popcat = true
export var has_buttercat = true
export var popcat_at = BOTTOM

# Popcat
export (Resource) var Popcat
export var popcat_speed = 150
export var popcat_last = 10
export var popcat_interval_min = 3
export var popcat_interval_max = 5
export var popcat_interval_threshold_min = 0.5
export var popcat_interval_threshold_max = 1.5

# Buttercat
export (Resource) var Buttercat
export var buttercat_speed = 200
export var buttercat_last = 10
export var buttercat_flip = false
export var buttercat_interval_min = 2
export var buttercat_interval_max = 5
export var buttercat_interval_threshold_min = 0.5
export var buttercat_interval_threshold_max = 1.5

# Items
#export (Resource) var SpaceHelmet
#export (Resource) var Sunglasses
#export (Resource) var Mohawk
#export (Resource) var Spike
#export (Resource) var Fireworks
export var item_speed = 100
export var item_last = 15

# Distance
export var distance = [0,0,0,0,0]
export var distance_increase = 0.01
export var total_distance = 0

# Difficulty
export var difficulty = 0
export var difficulty_increase = 0.001

# Nodes
onready var popcat_top = $Popcat/Top
onready var popcat_bottom = $Popcat/Bottom
onready var popcat_timer = $Timer/Popcat

onready var buttercat_top = $Buttercat/Top
onready var buttercat_bottom = $Buttercat/Bottom
onready var buttercat_timer = $Timer/Buttercat

onready var item_top = $Item/Top
onready var item_bottom = $Item/Bottom

onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.spawner = self
	popcat_timer.start()
	buttercat_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var level = global.altitude.level
	if level == global.altitude.SPACE:
		self.has_buttercat = true
		self.buttercat_flip = false
		self.has_popcat = false
		self.popcat_at = BOTTOM
	elif level == global.altitude.SKY:
		self.has_buttercat = true
		self.buttercat_flip = false
		self.has_popcat = false
	elif level == global.altitude.STREET:
		self.has_buttercat = true
		self.buttercat_flip = false
		self.has_popcat = true
		self.popcat_at = BOTTOM
	elif level == global.altitude.CAVE:
		self.has_buttercat = false
		self.has_popcat = true
		self.popcat_at = BOTH
	elif level == global.altitude.ASIA:
		self.has_buttercat = true
		self.buttercat_flip = true
		self.has_popcat = true
		self.popcat_at = TOP
	
	if !disabled:
		self.distance[level-1] += distance_increase
		self.difficulty += self.difficulty_increase
		var dis = 0
		for ele in distance:
			dis += floor(ele)
		self.total_distance = dis
	
# Start popcat timer
func start_popcat_timer():
	var from = popcat_interval_min - difficulty
	var to = popcat_interval_max - difficulty
	if from <= popcat_interval_threshold_min:
		from = popcat_interval_threshold_min
	if to <= popcat_interval_threshold_max:
		to = popcat_interval_threshold_max
	global.start_timer_rand(popcat_timer, from, to)
	
# Start buttercat timer
func start_buttercat_timer():
	var from = buttercat_interval_min - difficulty
	var to = buttercat_interval_max - difficulty
	if from <= buttercat_interval_threshold_min:
		from = buttercat_interval_threshold_min
	if to <= buttercat_interval_threshold_max:
		to = buttercat_interval_threshold_max
	global.start_timer_rand(buttercat_timer, from, to)

# Dettach all children from a node
func remove_children(parent):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

# Detach all enemy and item
func clear():
	remove_children(popcat_top)
	remove_children(popcat_bottom)
	remove_children(buttercat_top)
	remove_children(buttercat_bottom)
	remove_children(item_top)
	remove_children(item_bottom)

# Spawn a popcat
func spawn_popcat(at = BOTTOM, start_timer = false):
	var popcat = Popcat.instance()
	popcat.speed = popcat_speed
	popcat.last = popcat_last
	if at == TOP:
		popcat.flipped = true
		popcat_top.add_child(popcat)
	if at == BOTTOM:
		popcat_bottom.add_child(popcat)
	if at == BOTH:
		var pos = global.rand_int(0,1)
		if pos == 0:
			popcat.flipped = true
			popcat_top.add_child(popcat)
		else:
			popcat_bottom.add_child(popcat)
	if start_timer:
		start_popcat_timer()

func spawn_buttercat(start_timer = false):
	var buttercat = Buttercat.instance()
	buttercat.speed = buttercat_speed
	buttercat.last = buttercat_last
	buttercat_top.add_child(buttercat)
	buttercat.global_position.y = global.rand_float(buttercat_top.global_position.y, buttercat_bottom.global_position.y)
	if start_timer:
		start_buttercat_timer()

# Popcat spawn timer timeout
func _on_Popcat_timeout():
	if !self.disabled and self.has_popcat:
		spawn_popcat(popcat_at, true)

# Buttercat spawn timer timeout
func _on_Buttercat_timeout():
	if !self.disabled and self.has_buttercat:
		spawn_buttercat(true)
