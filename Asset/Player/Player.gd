#========================
# Player
#========================

extends KinematicBody2D

# Enums
enum {DRUM,ASIA,CAVE,STREET,SKY,SPACE}

# Exported Variables
export var speed = 200 # player speed
export var control = false # toggle player control
export var health = 5 # player health (heart count)
export var has_pistol = true # player has access to pistol
export var has_machine_gun = false # player has access to machine gun
export var has_laser_rifle = false # player has access to laser rifle
export var has_shotgun = false # player has access to shotgun
export var has_flamethrower = false # player has access to flame thrower
export var disabled = true # disable player control?
export var flipped = false # flip player sprite upside down (in asia)

export var lock_health = false # no health reduction

# Variables
var up = 0 # velocity in 4 directions
var down = 0
var left = 0
var right = 0
var velocity = Vector2(0,0) # overall velocity vector

# Nodes
onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time
func _ready():
	global.player = self # set global variable

# Called during the physics processing step of the main loop.
# Physics processing means that the frame rate is synced to the physics, i.e. the delta variable should be constant. delta is in seconds
func _physics_process(_delta):
	if !disabled:
		up = 0
		down = 0
		left = 0
		right = 0
		if Input.is_action_pressed("up") : # true when "up" is pressed, false when it's released
			up = -speed # note Y axis is pointing downwards
		if Input.is_action_pressed("down") :
			down = speed
		if Input.is_action_pressed("left") :
			left = -speed
		if Input.is_action_pressed("right") :
			right = speed
		velocity.x = left + right # make sure player doesn't move when both "left" and "right" are both pressed/released
		velocity.y = up + down # make sure player doesn't move when both "up" and "down" are both pressed/released
		# Moves the body along a vector. If the body collides with another, it will slide along the other body rather than stop immediately
		velocity = move_and_slide(velocity)
	if global.altitude.level == global.altitude.ASIA:
		flipped = true
		self.scale.y = -1
	else:
		flipped = false
		self.scale.y = 1
	if Input.is_action_just_released("altitude_increase") and !global.altitude.changing:
		global.altitude.change(global.altitude.level + 1)
	if Input.is_action_just_released("altitude_decrease") and !global.altitude.changing:
		global.altitude.change(global.altitude.level - 1)	

	if lock_health:
		health = 5
