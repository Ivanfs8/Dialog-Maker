extends Node
class_name Dialog, "res://addons/dialog_maker/icons/DialogIcon.png"

signal dialog_started(_dialog, ref)
signal dialog_ended
signal dialog_next(_dialog)

export (Resource) var dialog: Resource = dialog as TreeRes

export (NodePath) onready var dialog_player = get_node(dialog_player)

export (Array, String) var autoload_properties_fetch: PoolStringArray
export (Array, NodePath) var scene_properties_fetch: PoolStringArray

var index: int = -1
var sec_index: int = 0

func _ready():
	if dialog_player: connect("dialog_started", dialog_player, "_on_Dialog_dialog_started")

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
	
	return dict
	
	
