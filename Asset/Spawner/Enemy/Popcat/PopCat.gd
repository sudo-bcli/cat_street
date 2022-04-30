#========================
# Enemy/Popcat
#========================

extends Area2D

export var speed = 150
export var last = 12
export var attack = 1
export var attack_interval = 2
export var flipped = false
export var bullet_speed = 4
export var bullet_scale = Vector2(0.6,0.6)
export (Resource) var bubble

onready var death_timer = $DeathTimer
onready var attack_timer = $AttackTimer
onready var animation = $AnimatedSprite
onready var bullet_spawn = $BulletSpawn
onready var ufo = $UFO
onready var global = get_node("/root/Global")

func _ready():
	if global.altitude.level == global.altitude.SPACE:
		ufo.visible = true
		self.position.y -= 20
	else:
		ufo.visible = false
	global.start_timer(death_timer, last)
	global.start_timer(attack_timer, attack_interval)
	if flipped:
		self.scale.y = -1

# Called during the physics processing step of the main loop
func _physics_process(delta):
	self.position.x -= speed * delta

func _on_AttackTimer_timeout():
	animation.play('attack')

func _on_AnimatedSprite_animation_finished():
	if animation.animation == "attack":
		var bullet = bubble.instance()
		bullet.damage = attack
		bullet.last = 8
		var bullet_pos = bullet_spawn.global_position
		var player_pos = global.player.global_position
		var velocity = Vector2(-1,-1)
		velocity = (player_pos - bullet_pos).normalized()
		if flipped:
			velocity.y = -velocity.y
		if velocity.x > 0:
			velocity.x = -velocity.x
		bullet.velocity = velocity * bullet_speed
		bullet.scale = bullet_scale
		bullet_spawn.add_child(bullet)
		animation.play("idle")

func _on_DeathTimer_timeout():
	self.get_parent().remove_child(self)
	self.queue_free()

func _on_PopCat_body_entered(body):
	if body.is_in_group("Player"):
		body.health -= attack
		self.monitoring = false
		self.visible = false
