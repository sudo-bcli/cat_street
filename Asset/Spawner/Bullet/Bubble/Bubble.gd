#========================
# Bullet
#========================
extends Area2D

export var velocity = Vector2(0,0)
export var last = 10
export var damage = 1
export var modulate_target = 0.6
export var modulate_speed = 0.05

onready var death_timer = $DeathTimer
onready var global = get_node("/root/Global")
onready var sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	global.start_timer(death_timer, last)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position += velocity

# Remove this node
func _on_DeathTimer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= damage
		set_deferred("monitoring",false)
		set_deferred("visible",false)
