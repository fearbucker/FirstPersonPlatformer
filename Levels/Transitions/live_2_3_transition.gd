extends Control
@onready var your_time_was = $"Your Time Was"
@onready var retry = $Retry
@onready var next_level = $"Next Level"
@onready var your_best_time_was = $"Your Best Time was"
var menu_scene = "res://MenuScenes/Main Scene.tscn"
var curr_level = "res://Levels/Level2/level_2.tscn"

var lvl2save = "user://lvl2.save"
var lvl2time
var curr_time_path = "user://currtime.save"
var curr_time
# Called when the node enters the scene tree for the first time.
func _ready():
	load_score1()
	your_best_time_was.text = "Your best time was: " + number_round(lvl2time)
	load_curr_time()
	your_time_was.text = "Your times was: " + number_round(curr_time)
	
func number_round(time):
	return "%02d:%02d.%03d" % [int(fmod(time, 3600) / 60), int(fmod(time, 60)), int(fmod(time, 1) * 100)]

func load_curr_time():
	var file = FileAccess.open(curr_time_path, FileAccess.READ)
	curr_time = file.get_float()

func load_score1():
	if FileAccess.file_exists(lvl2save):
		var file = FileAccess.open(lvl2save, FileAccess.READ)
		lvl2time = file.get_float()

func _on_retry_pressed():
	get_tree().change_scene_to_file(curr_level)

func _on_next_level_pressed(): # TODO MAKE NEXT LEVEL
	pass # Replace with function body.

func _on_main_menu_pressed():
	get_tree().change_scene_to_file(menu_scene)
