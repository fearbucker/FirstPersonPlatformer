extends Control

#CREATE REFERENCE TO ALL LEVEL BEST TIMES HERE
@onready var level_1_best_time = $"CanvasLayer/Level 1 Best Time"
@onready var level_2_best_time = $"CanvasLayer/Level 2 Best Time"

# INDEX OF ALL SCORE FILES
var score_files = {
	"level1": "user://lvl1.save",
	"level2": "user://lvl2.save"
}

# ADD REFERENCE TO ALL LEVELS HERE
var level1 = "level1"
var level2 = "level2"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_score(level1, level_1_best_time)
	load_score(level2, level_2_best_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func text_assign(label, time):
	label.text = "%02d:%02d.%03d" % [int(fmod(time, 3600) / 60), int(fmod(time, 60)), int(fmod(time, 1) * 100)]



func load_score(level, label):
	if score_files.has(level) and FileAccess.file_exists(score_files[level]):
		var file = FileAccess.open(score_files[level], FileAccess.READ)
		if file:
			var time = file.get_float()
			file.close()
			text_assign(label, time)


#SCENE CHANGES
func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/Main/L_Main.tscn")

func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Levels/Level2/level_2.tscn")
