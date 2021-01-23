tool
extends Resource
class_name TreeRes

func get_class() -> String: return "TreeRes"

const DIALOGUE: Dictionary = {
	"chara_id": 0,
	"text": "",
	"portrait": null,
	"pos": 0,
	"flip": false
}

const START: Dictionary = {
	"chara_id": 0, 
	"portrait": null,
	"pos": 0,
	"flip": false
}

const CONDITION: Dictionary = {
	"name": "", 
	"type": 0,
	"comparator": 0,
	"value": ""
	}

enum COMP {EQUAL, NOT, LESS, MORE, LESS_OR_EQUAL, MORE_OR_EQUAL}

export (Array, Resource) var characters: Array = []

export var nodes_data: Array = [] #type, name, offset, size
export var connections: Array = [] #from(name), from_port, to(name), to_port
export var tree_data: Dictionary = {} #obtained from main_panel>TreeData>make_tree_data()

export var properties: Dictionary = {} #name: type

export var character_settings: Array = []

func get_file_name() -> String:
	var path: PoolStringArray = resource_path.split("/")
	var file_name: PoolStringArray = path[path.size()-1].split(".")
	return file_name[0]

func set_default_character_settings(id: int) -> void:
	character_settings[id]["file_name"] = characters[id].get_file_name()
	character_settings[id]["portrait"] = characters[id].portraits[0]
	character_settings[id]["pos"] = 0
	character_settings[id]["flip"] = false

func get_default_character_settings(id: int) -> Dictionary:
	var dict: Dictionary = {
		"file_name": characters[id].get_file_name(),
		"portrait": characters[id].portraits[0],
		"pos": 0,
		"flip": false
	}
	
	return dict

func update_character_settings(id: int, dialogue: Dictionary):
	character_settings[id]["file_name"] = characters[id].get_file_name()
	character_settings[id]["portrait"] = dialogue["portrait"]
	character_settings[id]["pos"] = dialogue["pos"]
	character_settings[id]["flip"] = dialogue["flip"]
	
	print("update_chara_set - id: ", id, " - pos - ", dialogue["pos"])

func apply_character_settings(id: int, dict: Dictionary) -> Dictionary:
	dict["portrait"] = character_settings[id]["portrait"]
	dict["pos"] = character_settings[id]["pos"]
	dict["flip"] = character_settings[id]["flip"]
	
	return dict
