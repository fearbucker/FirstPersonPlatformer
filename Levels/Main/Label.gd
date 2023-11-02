extends Label

var local_pos

# Reference to the player's MovementController or the relevant script
@onready var player = $"../Player"

func _process(_delta):
	# Get the player's velocity from the MovementController

	var velocity = player.velocity
	var lowgrav = player.is_in_low_gravity

	# Calculate the speed (magnitude of velocity) and round it to the nearest tenth
	var speed = round(velocity.length())
	var jump_amount = player.jump_amount

	# Update the Label text
	text = "VELOCITY: " + str(speed)
	text += "\n JUMP AMOUNT: " + str(jump_amount)
	if lowgrav:
		text += "\n LOW GRAVITY"
