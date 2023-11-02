extends Node3D

#Variables
@export_node_path("Camera3D") var cam_path := NodePath("Camera")
@onready var cam: Camera3D = get_node(cam_path)
@onready var interaction = $Camera/Interaction
@onready var hand = $Camera/Hand
@onready var animation_player = $WeaponAnimationPlayer
@onready var weapon_pivot = $Camera/WeaponPivot
@onready var weapon_hitbox = $Camera/WeaponPivot/WeaponMesh/WeaponHitbox
@onready var player = $".."
@onready var camera_animations = $Camera/camera_animations
@onready var hook = $Hook
@onready var line_helper = $LineHelper
@onready var line = $LineHelper/Line

# Hook properties
@export var hook_reach = 25
@export var grapple_point : NodePath
@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0

# Mouse variables
var mouse_axis := Vector2()
var rot := Vector3()

#Picked object properties
var picked_object
var pull_force = 20

# Grappling Variables
@export var max_grapple_speed := 1.5
@export var grapple_speed := .5 # <---- SPRING CONSTANT ALERT 
@export var rest_length := 1.0
var hooked := false
var grapple_position := Vector3()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line.hide()
	set_hook_reach()
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	head_bob()
	handle_hook()
	weapon_pivot_visibility()
	animation_handler()
	object_handler()
	
	#Camera Controls
	var joystick_axis := Input.get_vector(&"look_left", &"look_right",
			&"look_down", &"look_up")
	if joystick_axis != Vector2.ZERO:
		mouse_axis = joystick_axis * 1000.0 * delta
		camera_rotation()

# HOOK STUFF
func set_hook_reach() -> void:
	hook.scale.y = hook_reach

func handle_hook() -> void:
	check_hook_activation()
	var length := calculate_path()
	draw_hook(length)
	look_for_point()
	
func check_hook_activation() -> void:
	# Activate hook
	if Input.is_action_just_pressed("hook") and hook.is_colliding():
		hooked = true
		grapple_position = hook.get_collision_point()
		line.show()

	# Stop grappling
	elif Input.is_action_just_released("hook"):
		hooked = false
		line.hide()

func calculate_path() -> float:
	var player2hook: Vector3 = grapple_position - player.position
	var length := player2hook.length()
	if hooked:
		# if we more than 4 away from line, don't dampen speed as much
		if length > 4:
			player.velocity *= .999
		# Otherwise dampen speed more
		else:
			player.velocity *= .9
		
		# Hook's law equation
		var force := grapple_speed * (length - rest_length)
		
		# Clamp force to be less than max_grapple_speed
		if abs(force) > max_grapple_speed:
			force = max_grapple_speed
		
		# Preserve direction, but scale by force
		player.velocity += player2hook.normalized() * force
	
	return length
	
func draw_hook(length: float) -> void:
	var direction = grapple_position - line_helper.global_transform.origin
	var up = Vector3.UP
	if direction.normalized().dot(up) < 0.99:
		up = Vector3.RIGHT  # Choose a different up vector that is not nearly aligned
	line_helper.look_at(grapple_position, up)
	line.height = length
	line.position.z = length / -2

func look_for_point() -> void:
	var grapple_pt := get_node_or_null(grapple_point)
	if (grapple_pt and hook.is_colliding()) and !hooked:
		grapple_pt.position = hook.get_collision_point()
		grapple_pt.visible = true
	else:
		grapple_pt.visible = false

# ANIMATION STUFF
func head_bob():
	if player.is_on_floor() and player.velocity.length() > 6:
		camera_animations.play("head_bob")
	else:
		camera_animations.play("RESET")

func weapon_pivot_visibility():
	if picked_object == null:
		weapon_pivot.visible = true
	if picked_object != null:
		weapon_pivot.visible = false
		
func animation_handler():
	if player.is_wall_running == true and not animation_player.current_animation == "attack":
		animation_player.play("wallrun")
	elif player.is_wall_running == false and not animation_player.current_animation == "attack":
		if player.is_sprinting:
			animation_player.play("sprinting")
		else:
			animation_player.play("idle")
	if Input.is_action_just_pressed("Lclick") and not animation_player.current_animation == "attack":
		weapon_hitbox.monitoring = true
		animation_player.stop()
		animation_player.play("attack")

# OBJECT STUFF

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		
func drop_object():
	if picked_object != null:
		picked_object = null

func object_handler():
	if Input.is_action_just_pressed("ePress"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			drop_object()
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*pull_force)

func camera_rotation() -> void:
	# Horizontal mouse look.
	rot.y -= mouse_axis.x * mouse_sensitivity
	# Vertical mouse look.
	rot.x = clamp(rot.x - mouse_axis.y * mouse_sensitivity, -y_limit, y_limit)
	
	get_owner().rotation.y = rot.y
	rotation.x = rot.x

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		animation_player.play("idle")
		weapon_hitbox.monitoring = false
