extends PanelContainer

@export var save_button: Button
@export var exit_button: Button

signal open_menu_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	save_button.pressed.connect(on_save_button_pressed)
	exit_button.pressed.connect(on_exit_button_pressed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_menu"):
		if self.visible:
			get_tree().paused = false
			self.hide()
		else:
			self.show()
			save_button.grab_focus()
			get_tree().paused = true



func on_save_button_pressed():
	var dummy_save: Dictionary = {"field": "value"}
	SaveManager.save(dummy_save)

func on_exit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")
