extends Control

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
	if Input.is_action_just_pressed("hook") and self.is_visible_in_tree():
		get_tree().quit()
	if Input.is_action_just_pressed("M") and get_tree().is_paused:
		get_tree().change_scene_to_file("res://MenuScenes/Main Scene.tscn")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = false
