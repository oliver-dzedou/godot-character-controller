extends Node

##############
# Dependencies
##############
@export var state: Node
@export var event_bus: Node
@export var animation_player: AnimationPlayer

###########
# Built-ins
###########
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
######################
# Custom Functionality
######################
func play_animation(animation_name: String) -> void:
	animation_player.stop()
	animation_player.play(animation_name)
	
func is_playing_animation(animation: String) -> bool:
	return animation_player.current_animation == animation
