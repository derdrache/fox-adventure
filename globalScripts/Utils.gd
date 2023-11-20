extends Node

const SAVE_PATH = "res://savegame.bin"



func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data : Dictionary = {
		"levelDetails": GameManager.levelDetails,
		"playerPosition": var_to_str(GameManager.playerPosition)
	}
	
	var jsonString = JSON.stringify(data)
	
	file.store_line(jsonString)
	
	
	
func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var data = JSON.parse_string(file.get_line())
			GameManager.levelDetails = data["levelDetails"]
			GameManager.playerPosition = str_to_var(data["playerPosition"])

