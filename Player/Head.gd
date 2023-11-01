extends Node3D


@export_node_path("Camera3D") var cam_path := NodePath("Camera")
@onready var cam: Camera3D = get_node(cam_path)
@onready var interaction = $Camera/Interaction
@onready var hand = $Camera/Hand
@onready var animation_player = $WeaponAnimationPlayer
@onready var weapon_pivot = $Camera/WeaponPivot
@onready var player = $".."
@onready var camera_animations = $Camera/camera_animations

@export var mouse_sensitivity := 2.0
@export var y_limit := 90.0
var mouse_axis := Vector2()
var rot := Vector3()
var picked_object
var pull_force = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity = mouse_sensitivity / 1000
	y_limit = deg_to_rad(y_limit)

func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		
func drop_object():
	if picked_object != null:
		picked_object = null

# Called when there is an input event
func _input(event: InputEvent) -> void:
	# Mouse look (only if the mouse is captured).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_axis = event.relative
		camera_rotation()

func head_bob():
	if player.is_on_floor() and player.velocity.length() > 6:
		camera_animations.play("head_bob")
	else:
		camera_animations.play("RESET")

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:

	var joystick_axis := Input.get_vector(&"look_left", &"look_right",
			&"look_down", &"look_up")
	head_bob()
	
	if picked_object == null:
		weapon_pivot.visible = true
	if picked_object != null:
		weapon_pivot.visible = false
	
	if player.is_wall_running == true and not animation_player.current_animation == "attack":
		animation_player.play("wallrun")
	elif player.is_wall_running == false and not animation_player.current_animation == "attack":
		if player.is_sprinting:
			animation_player.play("sprinting")
		else:
			animation_player.play("idle")
	
	if Input.is_action_just_pressed("Lclick") and not animation_player.current_animation == "attack":
		animation_player.stop()
		animation_player.play("attack")
	
	if Input.is_action_just_pressed("ePress"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			drop_object()

	if joystick_axis != Vector2.ZERO:
		mouse_axis = joystick_axis * 1000.0 * delta
		camera_rotation()
	
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
