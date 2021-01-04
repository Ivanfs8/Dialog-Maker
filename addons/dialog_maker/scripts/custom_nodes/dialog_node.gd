extends Node
class_name Dialog, "res://addons/dialog_maker/icons/DialogIcon.png"

signal dialog_started(_dialog, ref)
signal dialog_ended
signal dialog_next(_dialog)

export (Resource) var dialog: Resource = dialog as TreeRes

export (NodePath) onready var dialog_player = get_node(dialog_player) as DialogPlayer

export (Array, String) var autoload_properties_fetch: PoolStringArray
export (Array, NodePath) var scene_properties_fetch: PoolStringArray

var index: int = -1
var sec_index: int = 0

#properties["name"].value
var properties: Dictionary = {}

class Prop:
	var _name: String
	var node: Node
	var path: String
	var value setget , get_value
	func get_value():
		return node.get_indexed(path)
	
	func _init(__name: String, _node: Node, _path: String):
		_name = __name
		node = _node
		path = _path

func _ready():
	if dialog_player: connect("dialog_started", dialog_player, "_on_Dialog_dialog_started")
	
	if dialog.properties.empty(): return
	
	for prop in dialog.properties:
		var found: bool = false
		for node_name in autoload_properties_fetch:
			var node: Node = get_node("/root/" + node_name)
			if node && node.get_indexed(":" + prop) != null:
				properties[prop] = Prop.new(prop, node, ":" + prop)
				found = true
				print("Found ", prop, " in ", node.name)
				break
		
		if found: continue
		else: for node_path in scene_properties_fetch:
			var node: Node = get_node(node_path)
			if node && node.get_indexed(":" + prop) != null:
				properties[prop] = Prop.new(prop, node, ":" + prop)
				found = true
				print("Found ", prop, " in ", node.name)
				break

func start_dialog():
	index = dialog.tree_data[0]["next"]
	var dialog_data: Dictionary = dialog.tree_data[index]
	
	sec_index = 0
	
	print("dialog_started")
	emit_signal( "dialog_started", get_dict(dialog_data, sec_index), self )

func _exit_tree():
	if Engine.editor_hint: return
	for sig in get_signal_connection_list("dialog_started"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("dialog_next"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("dialog_ended"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func request_next(choice: int = -1):
	if index == -1: 
		end_dialog()
		return
	
	var dialog_data: Dictionary = dialog.tree_data[index]
	
	match dialog_data["type"]:
		"SecuenceNode": 
			if sec_index < dialog_data["secuence"].size() -1 :
				sec_index += 1
			else:
				sec_index = 0
				index = dialog_data["next"]
		"ChoiceNode": 
			index = dialog_data["paths"][choice] if choice != -1 else -1
		_: index = -1
	
	if index == -1: end_dialog()
	else:
		print("dialog_next")
		emit_signal("dialog_next", get_dict(dialog.tree_data[index], sec_index) )

func end_dialog():
	index = -1
	print("dialog_ended")
	emit_signal("dialog_ended")
	
#	for sig in get_signal_connection_list("dialog_started"):
#		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("dialog_next"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("dialog_ended"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func get_dict(dialog_data: Dictionary, _sec_index: int = -1) -> Dictionary:
	var dict: Dictionary
	match dialog_data["type"]:
		"SecuenceNode": 
			dict = {
				"type": "Secuence",
				"name": dialog.characters[dialog_data["secuence"][_sec_index]["chara_id"]].display_name,
				"content": dialog_data["secuence"][_sec_index]["text"]
			}
		"ChoiceNode":
			dict = {
				"type": "Choice",
				"name": dialog.characters[dialog_data["question"]["chara_id"]].display_name,
				"content": dialog_data["question"]["text"],
				"choices": dialog_data["choices"]
			}
		"ConditionNode": 
			dict = {
				"type": "Condition",
				"conditions": dialog_data["conditions"] 
			}
			return dict
	
	if dialog_data.has("conditions"):
		print("conditions found")
		dict["conditions"] = []
		match dict["type"]:
			"Secuence": 
				var cond_node: Dictionary = dialog.tree_data[ dialog_data["conditions"][0]["id"] ]
				dict["conditions"].append(get_condition(cond_node))
				if !dict["conditions"][0]["meet"]: index = -1
			"Choice": 
				#the conditions have to match the choices, if there's no condition is equal null
				for cho in dict["choices"]: dict["conditions"].append(null)
				#fill the corresponding choices with the condition node index/id
				for cond in dialog_data["conditions"]:#id(of cond node), port(choice)
					dict["conditions"][cond["port"]] = cond["id"]
				#get the condition node and assing the readable condition to corresponding choice
				for i in dict["conditions"].size():
					if dict["conditions"][i] == null: continue #ignore choices whiout conditions
					var cond_index: int = dict["conditions"][i]
					#print("cond_index is ", cond_index)
					var cond_node: Dictionary = dialog.tree_data[cond_index]
					dict["conditions"][i] = get_condition(cond_node)
					#print(dict["conditions"][i])
	
	return dict
	
func get_condition(condition_node: Dictionary) -> Dictionary:
	var conditions: Array = condition_node["conditions"] #name, type, comparator, value
	var display_cond: String = ""
	for cond in conditions:
		display_cond += str(
			"[", cond["name"], 
			ConditionNode.get_condition_display(cond["comparator"]), 
			cond["value"],
			"]")
	
	return {"display": display_cond, "meet": match_conditions(conditions)}

#returns if all conditions are true, if theres an error it will return true
func match_conditions(conditions: Array) -> bool:
	for cond in conditions: #name, type, comparator, value
		var prop = properties[cond["name"]].value
		var value_str: String = cond["value"]
		var value
		#convert the value string to corresponding value
		match cond["type"]:
			TYPE_BOOL: value = true if value_str == "true" else false
			TYPE_INT: value = value_str.to_int()
			TYPE_REAL: value = value_str.to_float()
			TYPE_STRING: value = value_str
		match cond["comparator"]:
			TreeRes.COMP.EQUAL: if !prop == value: return false
			TreeRes.COMP.NOT: if !prop != value: return false
			TreeRes.COMP.LESS: if !prop < value: return false
			TreeRes.COMP.MORE: if !prop > value: return false
			TreeRes.COMP.LESS_OR_EQUAL: if !prop <= value: return false
			TreeRes.COMP.MORE_OR_EQUAL: if !prop >= value: return false

	return true
