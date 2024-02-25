extends Node

func save_game(saveFile = "game"):
	
	if GameManager.gameNumber < 0: return
	
	var save_path : String
	var data : Dictionary
	
	if saveFile == "game": 
		
		save_path = "user://savegame"+ str(GameManager.gameNumber)  +".bin"
		data = {
			"levelDetails": GameManager.levelDetails,
			"playerPosition": var_to_str(GameManager.playerPosition),
			"playTimeSeconds": GameManager.playTimeSeconds,
			"catMomsDone" : GameManager.catMomsDone
		}
	elif saveFile == "settings":
		save_path = "user://settings.bin"
		data = {
			"backgroundMusicVolumen" : GameManager.backgroundMusicVolumen,
			"soundEffectsVolumen" : GameManager.soundEffectsVolumen
		}
		
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var jsonString = JSON.stringify(data)
	file.store_line(jsonString)
	
func load_game(loadFile = "game"):
	var save_path : String
	var data
	
	if loadFile == "game":
		save_path = "user://savegame"+ str(GameManager.gameNumber) +".bin"
	elif loadFile == "settings":
		save_path = "user://settings.bin"
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	if FileAccess.file_exists(save_path):
		data = JSON.parse_string(file.get_line())
		
		if loadFile == "game":
			GameManager.levelDetails = data["levelDetails"]
			GameManager.playerPosition = str_to_var(data["playerPosition"])
			GameManager.playTimeSeconds = data["playTimeSeconds"] if data.has("playTimeSeconds") else 0
			if data.has("catMomsDone"): GameManager.catMomsDone = data["catMomsDone"]
		elif loadFile == "settings":
			GameManager.backgroundMusicVolumen = data["backgroundMusicVolumen"]
			GameManager.soundEffectsVolumen = data["soundEffectsVolumen"]
			
			var backgroundBus = AudioServer.get_bus_index("BackgroundMusic")
			AudioServer.set_bus_volume_db(backgroundBus, GameManager.backgroundMusicVolumen)
			if GameManager.backgroundMusicVolumen == -25: AudioServer.set_bus_mute(backgroundBus, true)
			
			var soundEffectBus = AudioServer.get_bus_index("SoundEffect")
			AudioServer.set_bus_volume_db(soundEffectBus, GameManager.soundEffectsVolumen)
			if GameManager.soundEffectsVolumen == -25: AudioServer.set_bus_mute(soundEffectBus, true)
func delete_game(gameNumber):
	var save_path = "user://savegame"+ str(gameNumber) +".bin"
	DirAccess.remove_absolute(save_path)
