extends Node

@export var hitpoints: int
@export var parent: Node

func die() -> void:
	parent.queue_free()

func take_damage(damage: int) -> void:
	hitpoints = hitpoints - damage
	if (hitpoints <= 0):
		die()
