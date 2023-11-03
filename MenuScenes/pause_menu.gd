extends Control

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
