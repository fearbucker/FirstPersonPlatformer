extends Control
@onready var level_1 = $"Level 1"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Levels/Main/L_Main.tscn")
