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
