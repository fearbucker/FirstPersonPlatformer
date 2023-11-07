extends Control

@onready var your_time_was = $"CanvasLayer/Your Time Was"

@onready var retry = $CanvasLayer/Retry

@onready var next_level = $"CanvasLayer/Next Level"

@onready var your_best_time_was = $"CanvasLayer/Your Best Time was"

var menu_scene = "res://MenuScenes/Main Scene.tscn"
var curr_level = "res://Levels/Main/L_Main.tscn"
var next_level_path = "res://Levels/Level2/level_2.tscn"

var lvlsave = "user://lvl1.save"
var lvltime
var curr_time_path = "user://currtime.save"
var curr_time
# Called when the node enters the scene tree for the first time.
func _ready():
	load_score1()
	your_best_time_was.text = "YOUR BEST TIME WAS: " + number_round(lvltime)
	load_curr_time()
	your_time_was.text = "YOUR TIME WAS: " + number_round(curr_time)
	
func number_round(time):
	return "%02d:%02d.%03d" % [int(fmod(time, 3600) / 60), int(fmod(time, 60)), int(fmod(time, 1) * 100)]

func load_curr_time():
	var file = FileAccess.open(curr_time_path, FileAccess.READ)
	curr_time = file.get_float()

func load_score1():
	if FileAccess.file_exists(lvlsave):
		var file = FileAccess.open(lvlsave, FileAccess.READ)
		lvltime = file.get_float()

func _on_retry_pressed():
	get_tree().change_scene_to_file(curr_level)

func _on_next_level_pressed():
	get_tree().change_scene_to_file(next_level_path)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file(menu_scene)
