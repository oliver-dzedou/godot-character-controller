extends Node

##############
# Dependencies
##############
@export var character_body: CharacterBody2D
@export var input_controller: Node
@export var state: Node

#########
# Signals
#########
# Inputs
signal move_input
signal jump_input
signal jump_input_released
signal attack_1_input
signal dash_input

# Movement
signal is_moving_changed
signal jumped
signal is_wall_jumping_changed
signal is_on_floor_changed
signal jump_counter_changed
signal is_dashing_changed
signal dash_counter_changed
signal is_dash_on_cooldown_changed
signal is_clinging_to_wall_right_changed
signal is_clinging_to_wall_left_changed
signal is_touching_wall_right_changed
signal is_touching_wall_left_changed
signal is_touching_ceiling_changed
signal last_wall_cling_changed
signal is_coyote_time_changed
signal is_jump_buffer_changed

# Combat
signal is_attack_1_changed

# State
signal is_facing_right_changed

###########
# Built-ins
###########
func _ready() -> void:
	# Inputs
	input_controller.move_input.connect(on_move_input)
	input_controller.jump_input.connect(on_jump_input)
	input_controller.jump_input_released.connect(on_jump_input_released)
	input_controller.dash_input.connect(on_dash_input)
	input_controller.attack_1_input.connect(on_attack_1_input)
	
	# Movement
	character_body.is_facing_right_changed.connect(on_is_facing_right_changed)
	character_body.jumped.connect(on_jumped)
	character_body.jump_counter_changed.connect(on_jump_counter_changed)
	character_body.is_wall_jumping_changed.connect(on_is_wall_jumping_changed)
	character_body.is_moving_changed.connect(on_is_moving_changed)
	character_body.is_on_floor_changed.connect(on_is_on_floor_changed)
	character_body.is_dashing_changed.connect(on_is_dashing_changed)
	character_body.dash_counter_changed.connect(on_dash_counter_changed)
	character_body.is_dash_on_cooldown_changed.connect(on_is_dash_on_cooldown_changed)
	character_body.is_clinging_to_wall_right_changed.connect(on_is_clinging_to_wall_right_changed)
	character_body.is_clinging_to_wall_left_changed.connect(on_is_clinging_to_wall_left_changed)
	character_body.is_touching_wall_right_changed.connect(on_is_touching_wall_right_changed)
	character_body.is_touching_wall_left_changed.connect(on_is_touching_wall_left_changed)
	character_body.last_wall_cling_changed.connect(on_last_wall_cling_changed)
	character_body.is_coyote_time_changed.connect(on_is_coyote_time_changed)
	character_body.is_jump_buffer_changed.connect(on_is_jump_buffer_changed)
	
######################
# Custom Functionality
######################
# Inputs
func on_move_input(direction: float) -> void:
	emit_signal("move_input", direction)
	
func on_jump_input() -> void:
	emit_signal("jump_input")
	
func on_jump_input_released() -> void:
	emit_signal("jump_input_released")
	
func on_attack_1_input() -> void:
	emit_signal("attack_1_input")
	
func on_dash_input(direction: float) -> void:
	emit_signal("dash_input", direction)
	
# Movement
func on_is_moving_changed(is_moving: bool) -> void:
	emit_signal("is_moving_changed", is_moving)
	
func on_jumped() -> void:
	emit_signal("jumped")
	
func on_jump_counter_changed(jump_counter: int) -> void:
	emit_signal("jump_counter_changed", jump_counter)

func on_is_wall_jumping_changed(is_wall_jumping: bool) -> void:
	emit_signal("is_wall_jumping_changed", is_wall_jumping)

func on_is_on_floor_changed(is_on_floor: bool) -> void:
	emit_signal("is_on_floor_changed", is_on_floor)
	
func on_is_dashing_changed(is_dashing: bool) -> void:
	emit_signal("is_dashing_changed", is_dashing)
	
func on_dash_counter_changed(dash_counter: int) -> void:
	emit_signal("dash_counter_changed", dash_counter)
	
func on_is_dash_on_cooldown_changed(is_dash_on_cooldown: bool) -> void:
	emit_signal("is_dash_on_cooldown_changed", is_dash_on_cooldown)
	
func on_is_clinging_to_wall_right_changed(collider: Object) -> void:
	emit_signal("is_clinging_to_wall_right_changed", collider)
	
func on_is_clinging_to_wall_left_changed(collider: Object) -> void:
	emit_signal("is_clinging_to_wall_left_changed", collider)
	
func on_is_touching_wall_right_changed(collider: Object) -> void:
	emit_signal("is_touching_wall_right_changed", collider)
	
func on_is_touching_wall_left_changed(collider: Object) -> void:
	emit_signal("is_touching_wall_left_changed", collider)
	
func on_last_wall_cling_changed(collider: Dictionary) -> void:
	emit_signal("last_wall_cling_changed", collider)
	
func on_is_coyote_time_changed(is_coyote_time: bool) -> void:
	emit_signal("is_coyote_time_changed", is_coyote_time)
	
func on_is_jump_buffer_changed(is_jump_buffer: bool) -> void:
	emit_signal("is_jump_buffer_changed", is_jump_buffer)

# State
func on_is_facing_right_changed(is_facing_right: bool) -> void:
	emit_signal("is_facing_right_changed", is_facing_right)
