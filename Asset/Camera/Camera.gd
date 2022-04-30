#========================
# Game Camera
#========================

extends Node2D

# Exported variables
# invisible bounderies to make sure player doesn't fly outside of the camera view
export var top = true # enable top boundery
export var bottom = true
export var left = true
export var right = true

# Variables
onready var Top = $Boundary/Top/CollisionShape2D
onready var Bottom = $Boundary/Bottom/CollisionShape2D
onready var Left = $Boundary/Left/CollisionShape2D
onready var Right = $Boundary/Right/CollisionShape2D

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	Top.disabled = !top
	Bottom.disabled = !bottom
	Left.disabled = !left
	Right.disabled = !right
