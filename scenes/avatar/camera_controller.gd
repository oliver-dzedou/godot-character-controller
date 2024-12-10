extends Node

###############
# Configuration
###############
@export var camera: Camera2D
@export var avatar: CharacterBody2D
@export var state: Node
@export var camera_focus_detector: Area2D
@export var camera_limit_detector_left: Area2D
@export var camera_limit_detector_right: Area2D
@export var camera_limit_detector_top: Area2D
@export var camera_limit_detector_bottom: Area2D
@export var ledge_detection: Area2D

@export var ledge_detection_offset: float = 250
@export var ledge_detection_buffer: float = 0.3
@export var vertical_threshold: float = 400
@export var offset_distance: float = 100
@export var smoothing_speed_horizontal_on_floor: float = 0.08
@export var smoothing_speed_horizontal_in_air: float = 0.04
@export var smoothing_speed_vertical: float = 0.04

const max_limit = 1000000

##############
# Local state
##############
var is_camera_area_exited_buffer = false
var is_on_ledge: bool = false
var camera_focus: Node = null

###########
# Built-ins
###########
func _ready() -> void:
	camera_focus_detector.area_entered.connect(on_camera_focus_entered)
	camera_focus_detector.area_exited.connect(on_camera_focus_exited)
	
	camera_limit_detector_left.area_entered.connect(on_camera_limit_detector_left_entered)
	camera_limit_detector_left.area_exited.connect(on_camera_limit_detector_left_exited)
	camera_limit_detector_right.area_entered.connect(on_camera_limit_detector_right_entered)
	camera_limit_detector_right.area_exited.connect(on_camera_limit_detector_right_exited)
	camera_limit_detector_top.area_entered.connect(on_camera_limit_detector_top_entered)
	camera_limit_detector_top.area_exited.connect(on_camera_limit_detector_top_exited)
	camera_limit_detector_bottom.area_entered.connect(on_camera_limit_detector_bottom_entered)
	camera_limit_detector_bottom.area_exited.connect(on_camera_limit_detector_bottom_exited)
	
	ledge_detection.area_entered.connect(on_ledge_detection_entered)
	ledge_detection.area_exited.connect(on_ledge_detection_exited)
	
func _physics_process(delta: float) -> void:
	if camera_focus:
		camera.global_position.x = lerp(camera.global_position.x, camera_focus.global_position.x, 0.02)
		camera.global_position.y = lerp(camera.global_position.y, camera_focus.global_position.y, 0.02)
		return
			
	# Horizontal
	var desired_camera_x = avatar.global_position.x
	if state.is_facing_right:
		desired_camera_x += offset_distance
	else:
		desired_camera_x -= offset_distance

	var smoothing_speed_horizontal
	if state.is_on_floor:
		if is_camera_area_exited_buffer:
			smoothing_speed_horizontal = 0.04
		else:
			smoothing_speed_horizontal = smoothing_speed_horizontal_on_floor
	else:
		smoothing_speed_horizontal = smoothing_speed_horizontal_in_air

 	# Vertical
	var desired_camera_y = avatar.global_position.y
	var v_smoothing = smoothing_speed_vertical
	if avatar.velocity.y > 500:
		v_smoothing = 0.08
	if avatar.velocity.y > 1000:
		v_smoothing = 0.16
	if avatar.velocity.y > 1500:
		v_smoothing = 0.24
	if avatar.velocity.y > 2000:
		v_smoothing = 0.32
		
	if is_on_ledge:
		desired_camera_y += ledge_detection_offset
	print(camera.limit_left)
	camera.global_position.x = lerp(camera.global_position.x, desired_camera_x, smoothing_speed_horizontal)
	camera.global_position.y = lerp(camera.global_position.y, desired_camera_y, v_smoothing)


######################
# Custom Functionality
######################

# Camera focus
func on_camera_focus_entered(area: Area2D):
	camera_focus = area
	
func on_camera_focus_exited(area: Area2D):
	Util.create_timer(0.6, on_camera_focus_exited_buffer)
	is_camera_area_exited_buffer = true
	camera_focus = null
	
func on_camera_focus_exited_buffer():
	is_camera_area_exited_buffer = false
	
# Camera limit
func on_camera_limit_detector_left_entered(area: Area2D):
	var pos = area.collision.global_position.x
	var p_pos = avatar.global_position.x
	if pos > p_pos:
		return
	var left = Util.get_shape_bounds(area.collision).left
	camera.limit_left = left

func on_camera_limit_detector_left_exited(area: Area2D):
	camera.limit_left = -max_limit
	
func on_camera_limit_detector_right_entered(area: Area2D):
	var pos = area.collision.global_position.x
	var p_pos = avatar.global_position.x
	if pos < p_pos:
		return
	var right = Util.get_shape_bounds(area.collision).right
	camera.limit_right = right

func on_camera_limit_detector_right_exited(area: Area2D):
	camera.limit_right = max_limit
	
func on_camera_limit_detector_top_entered(area: Area2D):
	var pos = area.collision.global_position.y
	var p_pos = avatar.global_position.y
	if pos > p_pos:
		return
	var top = Util.get_shape_bounds(area.collision).top
	camera.limit_top = top

func on_camera_limit_detector_top_exited(area: Area2D):
	camera.limit_top = -max_limit
	
func on_camera_limit_detector_bottom_entered(area: Area2D):
	var pos = area.collision.global_position.y
	var p_pos = avatar.global_position.y
	if pos < p_pos:
		return
	var bottom = Util.get_shape_bounds(area.collision).bottom
	camera.limit_bottom = bottom

func on_camera_limit_detector_bottom_exited(area: Area2D):
	camera.limit_bottom = max_limit
	
# Camera ledge
func on_ledge_detection_entered(area: Area2D):
	Util.create_timer(ledge_detection_buffer, on_ledge_detection_entered_buffer_expired)
	
func on_ledge_detection_exited(area: Area2D):
	if not state.is_on_floor:
		return
	is_on_ledge = false
	
func on_ledge_detection_entered_buffer_expired():
	is_on_ledge = true
	
func on_ledge_detection_exited_buffer_expired():
	if state.is_on_floor:
		return
	
