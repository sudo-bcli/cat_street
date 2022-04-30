#========================
# Audio Manager
#========================

extends Node2D

enum {DRUM,SPACE,SKY,STREET,CAVE,ASIA}

# Exported variables
export var fade_speed = 3000 # audio stream move in/out speed
export var music_hideout_x = 5000 # somewhere to hide audio streamers
export var volume = -10 # volume in db

# Variables
var current = 0 # music id in playlist, note Drum will always be played, setting playing to 0 means we are just playing Drum
var next = 0
var switching = false
var move_out
var move_in
var moved_out = false
var moved_in = false

# Nodes
onready var bgm_drum = $Music/Drum
onready var bgm_space = $Music/Space
onready var bgm_sky = $Music/Sky
onready var bgm_street = $Music/Street
onready var bgm_cave = $Music/Cave
onready var bgm_asia = $Music/Asia
onready var bgms = [bgm_drum,bgm_space,bgm_sky,bgm_street,bgm_cave,bgm_asia]
onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	# move all audio stream player for away so player can't hear them, then play all BGMs at once so they are synced
	for music in bgms:
		music.position.x = music_hideout_x
		music.play()
	global.audio = self # set global variable

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (switching):
		if (moved_out && moved_in):
			switching = false
			current = next
		if (current != 0):
			# move current audio player out
			if (move_out.position.x <= music_hideout_x):
				move_out.position.x += fade_speed * delta
			else:
				moved_out = true
		# move next audio player in
		if (move_in.position.x >= 0):
			move_in.position.x -= fade_speed * delta
		else:
			moved_in = true
	change_volume(volume)

# Play music
func play(id:int):
	# print error message if id is not in bgms
	if (id < 0 or id >= bgms.size()):
		print("id=",id," doesn't exist in playlist, could not play audio")
	else:
	# else, set variables
		next = id
		move_out = bgms[current]
		move_in = bgms[next]
		moved_out = false
		moved_in = false
		switching = true

# Set master volume
func change_volume(db:int):
	volume = db
	for music in bgms:
		music.volume_db = db
