tool
extends PanelContainer
class_name ChoicePanel

signal choice_edited

var index: int

onready var text_edit: TextEdit = $HBoxContainer/TextEdit
onready var delete_button: Button = $HBoxContainer/DeleteButton

func _exit_tree():
	if Engine.editor_hint: return
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])
	
	for sig in get_signal_connection_list("choice_edited"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func load_choice(choice: String):
	text_edit.text = choice

func get_choice() -> String:
	return text_edit.text
	
func on_edit():
	emit_signal("choice_edited")
