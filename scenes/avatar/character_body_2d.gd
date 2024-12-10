extends Node2D
#
#@export var sprite: Sprite2D
#@export var animation_player: AnimationPlayer
#@export var combat: Node
#@export var character_body: CharacterBody2D
#
#var is_facing_right: bool = true
#var is_moving: bool = false
#var is_attacking: bool = false
#var is_jumping: bool = false
#
#var attack_animations = ["attack_1_right", "attack_1_left"]
#
##func can_play_animation() -> bool:
	##if animation_player.is_playing && non_interruptible_animations.has(animation_player.current_animation):
		##return false
	##return true
	#
#func _physics_process(delta: float) -> void:
	#global_position = character_body.global_position
#
func _ready() -> void:
	Global.avatar = self
	#animation_player.animation_finished.connect(on_animation_finished)
	#combat.attack_1.connect(on_attack_1)
	#character_body.movement_started.connect(on_movement_started)
	#character_body.movement_stopped.connect(on_movement_stopped)
	#character_body.jumped.connect(on_jump)
	#
#func on_attack_1():
	#is_attacking = true
	#if is_facing_right:
		#animation_player.play("attack_1_right")
	#else:
		#animation_player.play("attack_1_left")
	#if is_moving:
		#on_movement_started()
	#else:
		#on_movement_stopped()
#
#func on_movement_started():
	#is_moving = true
	#if character_body.velocity.x >= 0:
		#sprite.flip_h = false
		#is_facing_right = true
	#else:
		#sprite.flip_h = true
		#is_facing_right = false
	#if is_attacking or is_jumping:
		#return
	#animation_player.play("run")
	#
#func on_movement_stopped():
	#is_moving = false
	#if is_attacking or is_jumping:
		#return
	#animation_player.play("idle")
#
#func on_jump():
	#if is_attacking:
		#return
	#is_jumping = true
	#animation_player.stop()
	#animation_player.play("jump")
	#
#func on_animation_finished(animation_name: String):
	#if animation_name == "jump":
		#is_jumping = false
	#if attack_animations.has(animation_name):
		#is_attacking = false
