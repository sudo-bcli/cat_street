#========================
# UI/HUD
#========================
extends Control

enum {TITLE, GAME, PAUSE, OVER}

export var state = TITLE
export var allow_reload = false

onready var hearts = [$Health/Heart1,$Health/Heart2,$Health/Heart3,$Health/Heart4,$Health/Heart5]
onready var distance = [$Distance/AnimatedSprite4,$Distance/AnimatedSprite3,$Distance/AnimatedSprite2,$Distance/AnimatedSprite1]
onready var pause = $Pause
onready var game_over = $GameOver
onready var any_key = $GameOver/AnyKey
onready var reload_timer = $ReloadTimer
onready var global = get_node("/root/Global")

func _ready():
	global.hud = self
	pause.visible = false
	game_over.visible = false
	self.pause_mode = Node.PAUSE_MODE_PROCESS # make sure this node will not pause

func _process(delta):
	# game over
	if state != OVER and global.player.health <= 0:
		game_over.visible = true
		for heart in hearts:
			heart.visible = false
		state = OVER
		global.player.disabled = true
		reload_timer.start()
	# update player health and distance
	if state == GAME:
		update_distance()
		update_health()
	
func update_health():
	var health = global.player.health
	if health > 5:
		health = 5
	for n in range(0, hearts.size()):
		if health >= n + 1:
			hearts[n].visible = true
		else:
			hearts[n].visible = false

func update_distance():
	var dis_str = str(global.spawner.total_distance)
	for n in range(0,distance.size()):
		if n + 1 <= dis_str.length():
			distance[n].play(dis_str[dis_str.length() - (n + 1)])
			distance[n].visible = true
		else:
			distance[n].visible = false

func _input(event):
	if event is InputEventKey:
		if event.pressed: # when any key is pressed
			if state == OVER and allow_reload == true:
				get_tree().reload_current_scene()
		if event.is_action_released("ui_cancel"):
			print("esc pressed, state", state)
			if state == GAME:
				state = PAUSE
				get_tree().paused = true
				pause.visible = true
				return
			if state == PAUSE:
				get_tree().paused = false
				pause.visible = false
				state = GAME
				return

func _on_ReloadTimer_timeout():
	self.allow_reload = true
	any_key.visible = true
