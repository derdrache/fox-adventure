extends Control

@onready var newGameButton = $VBoxContainer/NewGameButton

@onready var saveFileParent = $VBoxContainer/HBoxContainer

var saveFiles : Array
var saveFileContainerNode = preload("res://ui/load_window/save_file_container.tscn")
var saveSlots = [false,false, false]

func _input(event):
	if event.is_action_pressed("open_menu"):
		var safeFileNode 
		
		for node in saveFileParent.get_children():
			if node.has_focus(): safeFileNode = node
		
		if safeFileNode == null: return
		safeFileNode.delete_save_file()

func _ready():
	saveFiles = _get_save_files()
	
	_create_save_file_container()

	_set_focus()		

func _process(delta):
	if not false in saveSlots: 
		newGameButton.hide()
	else: newGameButton.show()

func _get_save_files():
	for i in GameManager.MAX_SAVE_FILES:
		var savePath = "user://savegame"+ str(i) +".bin"
	
		var file = FileAccess.open(savePath, FileAccess.READ)
		var data : Dictionary
	
		if FileAccess.file_exists(savePath):
			data = JSON.parse_string(file.get_line())
			saveFiles.append({"fileNumber": i, "data": data})
			saveSlots[i] = true
	
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
	if not false in saveSlots: return
	
	var nextFreeSaveSlot = 0
	
	for i in len(saveSlots):
		if saveSlots[i] == false: 
			nextFreeSaveSlot = i
			break
	
	GameManager.gameNumber = nextFreeSaveSlot
	GameManager.gameStart = Time.get_datetime_dict_from_system()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")

func _set_focus():
	if DisplayServer.is_touchscreen_available(): return

	if saveFileParent.get_child_count() > 0:
		saveFileParent.get_children()[0].grab_focus()
	else:
		newGameButton.grab_focus()
		
	newGameButton.focus_neighbor_right = newGameButton.get_path_to(saveFileParent.get_children()[0])
	newGameButton.focus_neighbor_bottom =newGameButton.get_path_to(saveFileParent.get_children()[0])
	newGameButton.focus_neighbor_top =newGameButton.get_path_to(saveFileParent.get_children()[0])
	newGameButton.focus_neighbor_left =newGameButton.get_path_to(saveFileParent.get_children()[0])

func delete_game(gameNumber):
	saveSlots[gameNumber]= false
