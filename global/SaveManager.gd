extends Node

@export var save_file_path = "user://"

func save(content: Dictionary):
	var file = FileAccess.open(save_file_path + "save_1.dat", FileAccess.WRITE)
	file.store_string(JSON.stringify(content))

func load_from_file():
	var file = FileAccess.open(save_file_path + "save_1.dat", FileAccess.READ)
	var content = file.get_as_text()
	var json_object = JSON.new()
	var error = json_object.parse(content) 
	if error == OK:
		var content_received = json_object.data
		if typeof(content_received) == TYPE_DICTIONARY:
			return content_received
		else:
			assert("Unexpected save data")
