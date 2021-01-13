tool
class_name DialogMaker

class Dialogue extends Object:
	var chara_id: int = 0
	var text: String = ""
	var portrait: Texture = null
	var pos: int = 0
	var flip: bool = false
	
	func _init(_chara_id: int = 0, _text: String = "", _portrait: Texture = null, var _pos: int = 0, _flip: bool = false):
		chara_id = _chara_id
		text = _text
		portrait = _portrait
		pos = _pos
		flip = _flip

class StartData extends Object:
	var chara_id: int = 0
	var portrait: Texture = null
	var pos: int = 0
	var flip: bool = false
	
	func _init(_chara_id: int = 0, _portrait: Texture = null, _pos: int = 0, _flip: bool = false):
		chara_id = _chara_id
		portrait = _portrait
		pos = _pos
		flip = _flip

enum COMP {EQUAL, NOT, LESS, MORE, LESS_OR_EQUAL, MORE_OR_EQUAL}

class Condition extends Object:
	var prop_name: String = ""
	var type: int = 0
	var comp: int = 0
	var value
	
	func _init(_prop_name: String = "", _type: int = 0, _comp: int = 0, _value = null):
		prop_name = _prop_name
		type = _type
		comp = _comp
		value = _value
