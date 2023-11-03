extends Control
@onready var your_time_was = $"Your Time Was"
@onready var retry = $Retry
@onready var next_level = $"Next Level"
@onready var your_best_time_was = $"Your Best Time was"

var lvl1save = "user://lvl1.save"
var lvl1time
var curr_time_path = "user://currtime.save"
var curr_time
# Called when the node enters the scene tree for the first time.
func _ready():
	load_score1()
	your_best_time_was.text = "Your best time was: " + str(lvl1time)
	load_curr_time()
	your_time_was.text = "Your time was: " + str(curr_time)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_curr_time():
	var file = FileAccess.open(curr_time_path, FileAccess.READ)
	curr_time = file.get_float()

func load_score1():
	if FileAccess.file_exists(lvl1save):
		var file = FileAccess.open(lvl1save, FileAccess.READ)
		lvl1time = file.get_float()


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Levels/Main/L_Main.tscn")

func _on_next_level_pressed(): # TODO MAKE NEXT LEVEL
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Levels/Main Scene.tscn")
