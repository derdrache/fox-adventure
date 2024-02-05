extends Node

func save_game():
	var save_path = "user://savegame"+ str(GameManager.gameNumber)  +".bin"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data : Dictionary = {
		"levelDetails": GameManager.levelDetails,
		"playerPosition": var_to_str(GameManager.playerPosition),
		"playTimeSeconds": GameManager.playTimeSeconds
	}
	var jsonString = JSON.stringify(data)
	file.store_line(jsonString)
	
func load_game():
	var save_path = "user://savegame"+ str(GameManager.gameNumber) +".bin"
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	if FileAccess.file_exists(save_path):
		var data = JSON.parse_string(file.get_line())
		GameManager.levelDetails = data["levelDetails"]
		GameManager.playerPosition = str_to_var(data["playerPosition"])
		GameManager.playTimeSeconds = data["playTimeSeconds"] if data.has("playTimeSeconds") else 0

func delete_game(gameNumber):
	var save_path = "user://savegame"+ str(gameNumber) +".bin"
	DirAccess.remove_absolute(save_path)
