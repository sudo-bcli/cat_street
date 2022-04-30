#========================
# Debug Console
#========================

extends Control

# Nodes
onready var fps = $Section/Game/FPS/Value
onready var resolution = $Section/Game/Resolution/Value
onready var health = $Section/Game/Health/Value
onready var total_distance = $Section/Game/TotalDistance/Value
onready var altitude_distance = $Section/Game/AltitudeDistance/Value
onready var difficulty = $Section/Game/Difficulty/Value
onready var altitude = $Section/Game/Altitude/Value
onready var volume = $Section/Game/Volume/Value
onready var screen = $Section/System/Screen/Value
onready var processor_count = $Section/System/ProcessorCount/Value
onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time
func _ready():
	screen.text = str(OS.get_screen_size()) + " " + str(OS.get_screen_dpi()) + " dpi" # read screen resolution
	processor_count.text = str(OS.get_processor_count()) # read processor count
	global.console = self # set global variable

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta):
	# toggle console by `
	if(Input.is_action_just_released("console")):
		
		self.visible = !self.visible
	# update debug info
	fps.text = str(Engine.get_frames_per_second())
	resolution.text = str(OS.window_size)
	altitude.text = str(global.altitude.height)
	volume.text = str(global.audio.volume) + 'db'
	health.text = str(global.player.health)
	altitude_distance.text = str(global.spawner.distance[global.altitude.level-1])
	total_distance.text = str(global.spawner.total_distance)
	difficulty.text = str(global.spawner.difficulty)
	
# Change altitude to space
func _on_Space_button_up():
	if !global.altitude.changing:
		global.altitude.change(global.altitude.SPACE)

# Change altitude to sky
func _on_Sky_button_up():
	if !global.altitude.changing:
		global.altitude.change(global.altitude.SKY)

# Change altitude to street
func _on_Street_button_up():
	if !global.altitude.changing:
		global.altitude.change(global.altitude.STREET)

# Change altitude to cave
func _on_Cave_button_up():
	if !global.altitude.changing:
		global.altitude.change(global.altitude.CAVE)

# Change altitude to asia
func _on_Asia_button_up():
	if !global.altitude.changing:
		global.altitude.change(global.altitude.ASIA)

# Increate music volume
func _on_Increase_Volume_button_up():
	global.audio.volume += 1

# Decrease music volume
func _on_Decrease_Volume_button_up():
	global.audio.volume -= 1

# Spawn popcat at top
func _on_PopCatTop_button_up():
	global.spawner.spawn_popcat(global.spawner.TOP, false)

# Spawn popcat at bottom
func _on_PopCatBottom_button_up():
	global.spawner.spawn_popcat(global.spawner.BOTTOM, false)

# Spawn buttercat
func _on_ButterCatLinear_button_up():
	global.spawner.spawn_buttercat(false)


func _on_LockHealth_pressed():
	global.player.lock_health = !global.player.lock_health
