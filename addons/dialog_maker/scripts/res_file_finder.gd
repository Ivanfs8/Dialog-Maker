extends Object
class_name ResFileFinder

static func get_files(path: String, type) -> Array:
	var names: Array = get_files_names(path)
	return get_files_res(path, names, type)

static func get_files_names(path: String) -> Array:
	var files: Array = []
	var dir: Directory = Directory.new()

	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		
		var file = dir.get_next()
		while file != "":
			files += [file]
			file = dir.get_next()
	
	return files

static func get_files_res(path: String, names: Array, type) -> Array:
	var res: Array = []
	
	var index: int = 0
	for _name in names:
		var resource = load(path+_name)
		if resource is type:
			res += [resource]
		index += 1
	
	return res
