class_name DataManager
extends Node

var debitarium = Data.Debitarium
var save_files = []


func _ready():
	load_save_files()
	
	
func load_save_files():
	save_files = SaveManager.load_save_files_internal()
	SaveManager.sort_save_files_by_last_modified(save_files)


func save_cur():
	SaveManager.save(debitarium.name, debitarium)
