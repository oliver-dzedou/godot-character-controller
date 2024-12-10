extends Node

class_name State

@export var character_body: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

signal transitioned

func process(delta: float) -> void:
	pass

func physics_process(delta: float) -> void:
	pass

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass
