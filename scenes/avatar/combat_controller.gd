extends Node

##############
# Dependencies
##############
@export var event_bus: Node
@export var state: Node

###############
# Configuration
###############
@export var attack_1_duration: float = 0.28
@export var attack_1_cooldown: float = 0.45

##############
# Local state
##############
var is_attack_1_on_cooldown = false

#########
# Signals
#########
signal is_attack_1_changed

###########
# Built-ins
###########
func _ready() -> void:
	event_bus.attack_1_input.connect(on_attack_1_input)
	for hitbox in get_children():
		hitbox.monitoring = false
		hitbox.area_entered.connect(on_hit)

######################
# Custom Functionality
######################
func on_hit(area: Area2D) -> void:
	area.get_parent().damageable.take_damage(10)
	
func on_attack_1_input() -> void:
	if state.is_attack_1 or is_attack_1_on_cooldown:
		return 
	emit_signal("is_attack_1_changed", true)
	is_attack_1_on_cooldown = true
	Util.create_timer(attack_1_cooldown, on_attack_1_cooldown_finished)
	Util.create_timer(attack_1_duration, on_attack_1_finished)
		
func on_attack_1_finished() -> void:
	emit_signal("is_attack_1_changed", false)

func on_attack_1_cooldown_finished() -> void:
	is_attack_1_on_cooldown = false
