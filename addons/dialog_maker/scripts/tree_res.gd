extends Resource
class_name TreeRes

func get_class() -> String: return "TreeRes"

const DIALOGUE: Dictionary = {
	"chara_id": 0,
	"text": ""
}

export (Array, Resource) var characters: Array = []

export var nodes_data: Array = [] #type, name, offset, size
export var connections: Array = [] #from(name), from_port, to(name), to_port
export var tree_data: Dictionary = {} #obtained from main_panel>TreeData>make_tree_data()

export var properties: Dictionary = {} #name: type
