###########
# Node Type
###########
extends Node

##############
# Dependencies
##############
@export var event_bus: Node
@export var debug: Node

##############
# Local state
##############
var is_facing_right: bool = true
var is_moving: bool = false
var is_on_floor: bool = false
var is_wall_jumping: bool = false
var is_dashing: bool = false
var is_dash_on_cooldown: bool = false
var is_clinging_to_wall_right: Object = null
var is_clinging_to_wall_left: Object = null
var is_touching_wall_right: Object = null
var is_touching_wall_left: Object = null
var last_wall_cling: Dictionary = { "wall": null, "side": null }
var is_attack_1: bool = false
var jump_counter: int = 0
var dash_counter: int = 0
var input_queue_enabled: bool = false
var is_coyote_time: bool = false
var is_jump_buffer: bool = false

###########
# Built-ins
###########
func _ready() -> void:
	event_bus.is_facing_right_changed.connect(on_is_facing_right_changed)
	event_bus.is_moving_changed.connect(on_is_moving_changed)
	event_bus.jump_counter_changed.connect(on_jump_counter_changed)
	event_bus.is_wall_jumping_changed.connect(on_is_wall_jumping_changed)
	event_bus.is_on_floor_changed.connect(on_is_on_floor_changed)
	event_bus.is_dashing_changed.connect(on_is_dashing_changed)
	event_bus.dash_counter_changed.connect(on_dash_counter_changed)
	event_bus.is_dash_on_cooldown_changed.connect(on_is_dash_on_cooldown_changed)
	event_bus.is_clinging_to_wall_right_changed.connect(on_is_clinging_to_wall_right_changed)
	event_bus.is_clinging_to_wall_left_changed.connect(on_is_clinging_to_wall_left_changed)
	event_bus.is_touching_wall_right_changed.connect(on_is_touching_wall_right_changed)
	event_bus.is_touching_wall_left_changed.connect(on_is_touching_wall_left_changed)
	event_bus.last_wall_cling_changed.connect(on_last_wall_cling_changed)
	event_bus.is_coyote_time_changed.connect(on_is_coyote_time_changed)
	event_bus.is_attack_1_changed.connect(on_is_attack_1_changed)
	event_bus.is_jump_buffer_changed.connect(on_is_jump_buffer_changed)

func _process(delta: float) -> void:
	debug.set_text(
		"is_facing_right: " + str(is_facing_right) + "\n" +
		"is_moving: " + str(is_moving) + "\n" +
		"jump_counter: " + str(jump_counter) + "\n" +
		"is_wall_jumping: " + str(is_wall_jumping) + "\n" +
		"is_on_floor: " + str(is_on_floor) + "\n" +
		"is_dashing: " + str(is_dashing) + "\n" +
		"dash_counter: " + str(dash_counter) + "\n" +
		"is_dash_on_cooldown: " + str(is_dash_on_cooldown) + "\n" +
		"is_clinging_to_wall_right: " + str(is_clinging_to_wall_right) + "\n" +
		"is_clinging_to_wall_left: " + str(is_clinging_to_wall_left) + "\n" +
		"is_touching_wall_right: " + str(is_touching_wall_right) + "\n" +
		"is_touching_wall_left: " + str(is_touching_wall_left) + "\n" +
		"last_wall_cling: " + str(last_wall_cling) + "\n" +
		"is_coyote_time: " + str(is_coyote_time) + "\n" +
		"is_jump_buffer: " + str(is_jump_buffer) + "\n" +
		"is_attack_1: " + str(is_attack_1) + "\n"
	)

######################
# Custom Functionality
######################
# Movement
func on_is_facing_right_changed(_is_facing_right: bool) -> void:
	is_facing_right = _is_facing_right

func on_is_moving_changed(_is_moving: bool) -> void:
	is_moving = _is_moving

func on_jump_counter_changed(_jump_counter: int) -> void:
	jump_counter = _jump_counter
	
func on_is_wall_jumping_changed(_is_wall_jumping: bool) -> void:
	is_wall_jumping = _is_wall_jumping

func on_is_on_floor_changed(_is_on_floor: bool) -> void:
	is_on_floor = _is_on_floor
	
func on_is_dashing_changed(_is_dashing: bool) -> void:
	is_dashing = _is_dashing
	
func on_dash_counter_changed(_dash_counter: int) -> void:
	dash_counter = _dash_counter
	
func on_is_dash_on_cooldown_changed(_is_dash_on_cooldown: bool) -> void:
	is_dash_on_cooldown = _is_dash_on_cooldown

func on_is_clinging_to_wall_right_changed(collider: Object) -> void:
	is_clinging_to_wall_right = collider

func on_is_clinging_to_wall_left_changed(collider: Object) -> void:
	is_clinging_to_wall_left = collider
	
func on_is_touching_wall_right_changed(collider: Object) -> void:
	is_touching_wall_right = collider
	
func on_is_touching_wall_left_changed(collider: Object) -> void:
	is_touching_wall_left = collider
		
func on_last_wall_cling_changed(collider: Dictionary) -> void:
	last_wall_cling = collider
	
func on_is_coyote_time_changed(_is_coyote_time: bool) -> void:
	is_coyote_time = _is_coyote_time
	
func on_is_jump_buffer_changed(_is_jump_buffer: bool) -> void:
	is_jump_buffer = _is_jump_buffer
# Combat
func on_is_attack_1_changed(_is_attack_1) -> void:
	is_attack_1 = _is_attack_1
