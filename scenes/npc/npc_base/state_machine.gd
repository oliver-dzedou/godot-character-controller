extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready():
	current_state = initial_state
	for child in get_children():
		if child is State:
			states[child.state_name] = child
			child.transitioned.connect(on_state_transition)

func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)

func on_state_transition(new_state_name: String) -> void:
	if current_state.state_name == new_state_name:
		return
	var new_state = states[new_state_name]
	current_state.exit_state()
	new_state.enter_state()
	current_state = new_state
