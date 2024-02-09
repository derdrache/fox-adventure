extends Control

var saveFiles : Array
var saveFileContainerNode = preload("res://ui/load_window/save_file_container.tscn")


func _ready():
	saveFiles = _get_save_files()
	
	_create_save_file_container()

func _process(delta):
	pass

func _get_save_files():
	var saveFiles :Array
	
	for i in GameManager.MAX_SAVE_FILES:
		var savePath = "user://savegame"+ str(i) +".bin"
	
		var file = FileAccess.open(savePath, FileAccess.READ)
		var data : Dictionary
	
		if FileAccess.file_exists(savePath):
			data = JSON.parse_string(file.get_line())
			saveFiles.append(data)
	
	return saveFiles
	
func _create_save_file_container():
	for i in len(saveFiles):
		var saveFileContainer = saveFileContainerNode.instantiate()
		saveFileContainer.gameNumber = i
		saveFileContainer.saveData = saveFiles[i]
		$VBoxContainer/HBoxContainer.add_child(saveFileContainer)

func _on_new_game_button_pressed():
	var savedGamesCount = len(saveFiles)
	GameManager.gameNumber = savedGamesCount
	GameManager.gameStart = Time.get_datetime_dict_from_system()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")

