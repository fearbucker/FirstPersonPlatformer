extends Camera3D

var rotation_speed = Vector3(0.2, 0.0, 0.0)  # Adjust the X-axis rotation speed.
var amplitude = 5  # Adjust this value to control the sway intensity.
var time_elapsed = 0.0

var move_speed = 0.01  # Adjust this value for the forward movement speed.

func _ready():
	pass  # Replace with function body if needed.

func _process(delta):
	time_elapsed += delta
	var angle = sin(time_elapsed * rotation_speed.x) * amplitude
	rotation_degrees = Vector3(angle, 0, 0)

	# Move the camera forward along the Z-axis.
	var translation = -transform.basis.z * move_speed
	translate(translation)
