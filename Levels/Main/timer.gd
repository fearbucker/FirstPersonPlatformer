extends Panel

var time: float = 0.0
var minutes : int = 0
var seconds: int = 0
var msec: int = 0
var best_time : float = -1
var save_path = "user://lvl1.save"
var curr_time
var curr_time_path = "user://currtime.save"

func _ready():
	load_best_time()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+= delta
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % minutes
	$Seconds.text = "%02d." % seconds
	$Msecs.text = "%03d" % msec
	$BestTime.text = "%02d:%02d.%03d" % [int(fmod(best_time, 3600) / 60), int(fmod(best_time, 60)), int(fmod(best_time, 1) * 100)]
	
func stop() -> void:
	set_process(false)
	

func _on_victory_zone_area_entered(area):
	stop()
	save_curr_time()
	if best_time < 0 or time < best_time:
		best_time = time
		save_best_time()

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Levels/Transitions/lvl_1_2_transition.tscn")


func save_best_time() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE_READ)
	file.store_float(best_time)

func load_best_time():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			best_time = file.get_float()
			file.close()

func save_curr_time():
	var file = FileAccess.open(curr_time_path, FileAccess.WRITE_READ)
	file.store_float(time)

func load_curr_time():
	var file = FileAccess.open(curr_time_path, FileAccess.READ)
	curr_time = file.get_float()
