extends Resource
class_name TreeRes

const DIALOGUE: Dictionary = {
	"chara_id": 0,
	"text": ""
}

class Dialogue:
	var character_id: int = 0
	var text: String = ""

class Choice:
	var text: String = ""

export (Array, String) var characters: Array = []

export var nodes_data: Array = []
export var connections: Array = []
export var tree_data: Dictionary = {}
