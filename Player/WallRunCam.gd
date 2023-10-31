extends Node


@export_node_path("MovementController") var controller_path := NodePath("../")
@export var wall_run_angle = 15
var wall_run_current_angle = 0
var side = ""
@onready var controller: MovementController = get_node(controller_path)
@onready var collision = $"../Collision"

@export_node_path("Node3D") var head_path := NodePath("../Head")
@onready var cam: Camera3D = get_node(head_path).cam
@onready var player = $".."
var local_pos

@onready var normal_speed: int = controller.speed
@onready var normal_fov: float = cam.fov
func get_side(point):
	if point.x < 0:
		return "RIGHT"
	elif point.x > 0:
		return "LEFT"
	else:
		return "CENTER"

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	local_pos = collision.to_local(collision.position)
	side = get_side(local_pos)
	if player.is_wall_running:
		print(collision.to_local(collision.position))
		if side == "LEFT":
			wall_run_current_angle = delta * -15
			wall_run_current_angle = clamp(wall_run_current_angle, -wall_run_angle, wall_run_angle)
		elif side == "RIGHT":
			wall_run_current_angle = delta * 15
			wall_run_current_angle = clamp(wall_run_current_angle, -wall_run_angle, wall_run_angle)
	else:
		if wall_run_current_angle > 0:
			wall_run_current_angle -= delta * 40
			wall_run_current_angle = max(0, wall_run_current_angle)
		elif wall_run_current_angle < 0:
			wall_run_current_angle += delta * 40
			wall_run_current_angle = max(0, wall_run_current_angle)
	cam.rotation = lerp(cam.rotation, Vector3(0, 0, 1) * wall_run_current_angle, .2)
	
