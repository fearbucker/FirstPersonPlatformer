extends Control
@onready var level_1 = $"Level 1"
@onready var level_1_best_time = $"Level 1 Best Time"

var lvl1save = "user://lvl1.save"
var lvl1time

# Called when the node enters the scene tree for the first time.
func _ready():
	load_score1()
	level_1_best_time.text = str(lvl1time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/Main/L_Main.tscn")
	
func load_score1():
	if FileAccess.file_exists(lvl1save):
		var file = FileAccess.open(lvl1save, FileAccess.READ)
		if file:
			lvl1time = file.get_float()
			file.close()
