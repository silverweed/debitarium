extends Control

onready var debitarium_list = $CenterContainer/VBoxContainer/DebitariumListContainer/DebitariumList

func _ready():
	for saved in gDataManager.save_files:
		var entry = preload("res://misc/RemovableLabel.tscn").instance()
		debitarium_list.add_child(entry)
		entry.disconnect_signals()
		entry.button.connect("pressed", self, "on_entry_pressed", [entry, saved])
		entry.left_label.text = basename(saved.path)
		entry.left_label.theme = preload("res://EvenSmallerLabelTheme.tres")


static func basename(path):
	var idx = path.rfind("/")
	return path.substr(idx + 1)
	
	
func on_entry_pressed(entry: RemovableLabel, saved: SaveManager.SaveFile):
	# TODO: ask confirmation
	entry.queue_free()
	gDataManager.delete_file(saved.path)
