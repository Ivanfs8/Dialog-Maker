tool
extends PanelContainer
class_name ChoicePanel

signal choice_edited

var index: int

onready var text_edit: TextEdit = $HBoxContainer/TextEdit
onready var delete_button: Button = $HBoxContainer/DeleteButton

func load_choice(choice: String):
	text_edit.text = choice

func get_choice() -> String:
	return text_edit.text
	
func on_edit():
	emit_signal("choice_edited")
