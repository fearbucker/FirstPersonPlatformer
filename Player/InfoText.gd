extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect to the signals from the MovementController
	var movement_controller = $../MovementController  # Replace with the actual path to your MovementController
	if movement_controller:
		movement_controller.connect("velocity_changed", self, "_on_velocity_changed")
		movement_controller.connect("jump_amount_changed", self, "_on_jump_amount_changed")

# Signal handler for velocity_changed
func _on_velocity_changed(velocity):
	text = "Velocity: " + str(velocity)

# Signal handler for jump_amount_changed
func _on_jump_amount_changed(jump_amount):
	text += "\nJump Amount: " + str(jump_amount)
