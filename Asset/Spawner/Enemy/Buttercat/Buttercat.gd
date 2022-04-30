#========================
# Enemy/Buttercat
#========================

extends Area2D

export var speed = 120
export var last = 12
export var attack = 1
export var flipped = false

onready var death_timer = $DeathTimer
onready var animation = $Cat
onready var balloon = $Balloon
onready var rocket = $Rocket
onready var fireworks = $Fireworks
onready var global = get_node("/root/Global")

func _ready():
	balloon.visible = false
	rocket.visible = false
	fireworks.visible = false
	var level = global.altitude.level
	if level == global.altitude.SKY:
		self.speed = self.speed * 1.4
	if level == global.altitude.SPACE:
		self.speed = self.speed * 1.7
	if level == global.altitude.ASIA:
		self.speed = self.speed * 1.6
	if level == global.altitude.SPACE:
		rocket.visible = true
	elif level == global.altitude.ASIA:
		fireworks.visible = true
		self.scale.y = -self.scale.y
	else:
		balloon.visible = true
	global.start_timer(death_timer, last)
	if flipped:
		self.scale.y = -1

func _physics_process(delta):
	self.position.x -= speed * delta

func _on_DeathTimer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()

func _on_ButterCat_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= self.attack
		set_deferred("monitoring", false)
		set_deferred("visible", false)
