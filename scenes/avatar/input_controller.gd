extends Node

##############
# Dependencies
##############
@export var state: Node
@export var event_bus: Node

#########
# Signals
#########
signal jump_input
signal jump_input_released
signal move_input
signal attack_1_input
signal dash_input

###########
# Built-ins
###########

func _process(delta: float) -> void:
	handle_attack_1()

func _physics_process(delta: float) -> void:
	handle_basic_movement()
	handle_jump()
	handle_jump_released()
	handle_dash()

######################
# Custom Functionality
######################
func handle_basic_movement() -> void:
	if state.is_dashing:
		return
	var direction := Input.get_axis("move_left", "move_right")
	emit_signal("move_input", direction)
	
func handle_jump() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump"):
		emit_signal("jump_input")
		
func handle_jump_released() -> void:
	if Input.is_action_just_released("jump"):
		emit_signal("jump_input_released")

func handle_dash() -> void:
	if Input.is_action_just_pressed("dash"):
		var direction := Input.get_axis("move_left", "move_right")
		emit_signal("dash_input", direction)

func handle_attack_1() -> void:
	if Input.is_action_just_pressed("attack"):
		emit_signal("attack_1_input")
