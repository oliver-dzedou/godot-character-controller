extends Node2D

##############
# Dependencies
##############
@export var event_bus: Node
@export var sprite: Sprite2D

###########
# Built-ins
###########
func _ready() -> void:
	event_bus.is_facing_right_changed.connect(on_is_facing_right_changed)

######################
# Custom Functionality
######################
func on_is_facing_right_changed(is_facing_right: bool) -> void:
	if is_facing_right:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
