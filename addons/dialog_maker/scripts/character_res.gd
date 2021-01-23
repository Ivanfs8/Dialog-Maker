tool
extends Resource
class_name CharacterRes

export var display_name: String
export var color: Color

export (Array, Texture) var portraits: Array

func get_file_name() -> String:
	var path: PoolStringArray = resource_path.split("/")
	var file_name: PoolStringArray = path[path.size()-1].split(".")
	return file_name[0]
