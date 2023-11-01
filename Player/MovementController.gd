extends CharacterBody3D

class_name MovementController

# Define signals for velocity and jump_amount
signal velocity_changed(velocity)
signal jump_amount_changed(jump_amount)

@export var gravity_multiplier := 3.0
@export var speed := 20
@export var sprint_speed := 25
@export var acceleration := 8
@export var deceleration := 10
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10
@export var crouch_speed := 5 # Adjust the crouch speed as needed
var max_jumps := 2
var boost := 20
var direction := Vector3()
var input_axis := Vector2()
var is_in_low_gravity := false
var low_gravity_timer := 0.0
var low_gravity_duration := .2  # Adjust as needed
var is_crouching := false
var is_sprinting := false
var jump_amount := max_jumps
var is_wall_running: get = _get_wallrun


# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = 18
@onready var collision = $Collision
@onready var crouch_collision = $CrouchCollision
@onready var head = $Head

func _get_wallrun():
	return is_wall_running

#Handles Wall Running
func wall_run():
	if is_on_wall_only():
		jump_amount = max_jumps
		is_wall_running = true
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			var wall_boost = get_wall_normal() * boost
			velocity = wall_boost + Vector3(0, jump_height, 0) + direction * 2
			is_in_low_gravity = true
			low_gravity_timer = 0.0
	else:
		is_wall_running = false

#Handles crouch function 
func crouch():
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		head.position.y = lerp(head.position.y,.01, 1.0)
		crouch_collision.disabled = false
		collision.disabled = true
	else:
		is_crouching = false
		head.position.y = .64
		crouch_collision.disabled = true
		collision.disabled = false
		
#Handles jump function
func jump():
	if Input.is_action_just_pressed("jump") and jump_amount > 0:
		velocity.y = jump_height
		jump_amount -= 1

# Handles Sprint function
func sprint():
	if Input.is_action_pressed("sprint") and (is_on_floor() or is_on_wall()):
		is_sprinting = true
	else:
		is_sprinting = false
		
	if is_sprinting:
		speed = sprint_speed
	else:
		speed = 20

func _physics_process(delta: float) -> void:
	input_axis = Input.get_vector("move_back", "move_forward", "move_left", "move_right")
	direction_input()
	wall_run()
	crouch()
	sprint()
	jump()
	
	# After updating velocity
	emit_signal("velocity_changed", velocity)
	
	# After reducing jump_amount
	emit_signal("jump_amount_changed", jump_amount)

	
	if is_in_low_gravity:
		low_gravity_timer += delta
		if low_gravity_timer >= low_gravity_duration:
			is_in_low_gravity = false

	if is_on_floor():
		jump_amount = 1
	
	if not is_in_low_gravity:
		velocity.y -= gravity * delta
		
	if is_crouching:
		# Reduce speed when crouching
		speed = crouch_speed
		is_crouching = true
	else:
		if not is_sprinting:
			speed = 20  # Reset speed when not crouching
		is_crouching = false
	accelerate(delta)
	move_and_slide()

func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y

func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0

	var temp_accel: float
	var target: Vector3 = direction * speed

	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration

	if not is_on_floor():
		temp_accel *= air_control

	temp_vel = temp_vel.lerp(target, temp_accel * delta)

	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
