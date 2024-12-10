extends Control

@export var start: Button
@export var settings: Button
@export var exit: Button
@export var exit_popup: VBoxContainer
@export var exit_confirm: Button
@export var exit_deny: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_popup.hide()
	exit.pressed.connect(on_exit_press)
	exit_confirm.pressed.connect(on_exit_confirm_press)
	exit_deny.pressed.connect(on_exit_deny_press)
	start.pressed.connect(on_start_press)
	start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_start_press() -> void:
	get_tree().change_scene_to_file("res://scenes/game/Game.tscn")

func on_exit_press() -> void:
	exit_popup.show()
	exit_deny.grab_focus()
	
func on_exit_confirm_press() -> void:
	get_tree().quit()
	
func on_exit_deny_press() -> void:
	start.grab_focus()
	exit_popup.hide()
