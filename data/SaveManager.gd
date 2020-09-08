class_name SaveManager
extends Object

const SAVE_DIRECTORY: String = "user://saves/"

class SaveFile:
	var path: String
	var last_modified: int
	
	func _init(file: File):
		path = file.get_path()
		last_modified = file.get_modified_time(path)


static func load_save_files_internal() -> Array: # of SaveFile
	var dir = Directory.new()
	var err = dir.open(SAVE_DIRECTORY)
	if err != OK:
		print("Save directory ", SAVE_DIRECTORY, " not found")
		return []
	
	var files: Array = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var file = File.new()
			err = file.open(SAVE_DIRECTORY + file_name, File.READ)
			if err == OK:
				files.append(SaveFile.new(file))
		file_name = dir.get_next()

	dir.list_dir_end()
	print("Found ", len(files), " save files.")
	return files


class SaveFileSorter:
	static func is_save_file_more_recent(a: SaveFile, b: SaveFile) -> bool:
		return a.last_modified > b.last_modified
	

static func sort_save_files_by_last_modified(files: Array):
	files.sort_custom(SaveFileSorter, "is_save_file_more_recent")
	

static func save(fname: String, dbt: Data.Debitarium):
	assert(dbt != null)
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIRECTORY):
		dir.make_dir(SAVE_DIRECTORY)
	
	if !fname.begins_with(SAVE_DIRECTORY):
		fname = SAVE_DIRECTORY + fname
		
	var file = File.new()
	var err = file.open(fname, File.WRITE)
	if err != OK:
		print("Failed to open " + fname)
		return
	
	file.store_string(JSON.print(dbt.serialize()))
	
	print("Saved data to " + fname)
	
	file.close()


static func load_save(fname: String) -> Data.Debitarium:
	if !fname.begins_with(SAVE_DIRECTORY):
		fname = SAVE_DIRECTORY + fname
	var file = File.new()
	var err = file.open(fname, File.READ)
	if err != OK:
		print("Failed to open " + fname)
		return null
	var raw = file.get_as_text()
	var dbt = Data.Debitarium.new("empty", ["placeholder"])
	if dbt.deserialize(raw):
		print("Loaded save file ", fname)
		return dbt
	else:
		print("load_save(", fname, ") failed")
		return null


static func delete_file(fname: String):
	if !fname.begins_with(SAVE_DIRECTORY):
		fname = SAVE_DIRECTORY + fname
	var dir = Directory.new()
	dir.remove(fname)
