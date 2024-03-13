extends Control

@onready var saveFileParent = $VBoxContainer/HBoxContainer

var saveFiles : Array
var saveFileContainerNode = preload("res://ui/load_window/save_file_container.tscn")
var nextFreeSaveSlot = 0

func _ready():
	saveFiles = _get_save_files()
	
	_create_save_file_container()

	_set_focus()		
		
func _get_save_files():
	for i in GameManager.MAX_SAVE_FILES:
		var savePath = "user://savegame"+ str(i) +".bin"
	
		var file = FileAccess.open(savePath, FileAccess.READ)
		var data : Dictionary
	
		if FileAccess.file_exists(savePath):
			data = JSON.parse_string(file.get_line())
			saveFiles.append({"fileNumber": i, "data": data})
			nextFreeSaveSlot += 1
		else: if nextFreeSaveSlot < 0 :nextFreeSaveSlot = i
	
	return saveFiles
	
func _create_save_file_container():
	for i in len(saveFiles):
		var saveFileContainer = saveFileContainerNode.instantiate()
		saveFileContainer.deleteGame.connect(delete_game)
		var saveFileNumber = saveFiles[i]["fileNumber"]

		saveFileContainer.gameNumber = saveFiles[i]["fileNumber"]
		saveFileContainer.saveData = saveFiles[i]["data"]
		$VBoxContainer/HBoxContainer.add_child(saveFileContainer)

func _on_new_game_button_pressed():
	if nextFreeSaveSlot > 2: return

	GameManager.gameNumber = nextFreeSaveSlot
	GameManager.gameStart = Time.get_datetime_dict_from_system()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")

func _set_focus():
	if DisplayServer.is_touchscreen_available(): return

	if saveFileParent.get_child_count() > 0:
		saveFileParent.get_children()[0].grab_focus()
	else:
		$VBoxContainer/NewGameButton.grab_focus()

func delete_game():
	nextFreeSaveSlot -= 1
