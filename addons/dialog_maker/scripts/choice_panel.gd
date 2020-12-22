tool
extends PanelContainer
class_name ChoicePanel

signal choice_edited

var index: int

onready var text_edit: TextEdit = $HBoxContainer/TextEdit
onready var delete_button: Button = $HBoxContainer/DeleteButton

func load_choice(choice: TreeRes.Choice):
	text_edit.text = choice.text

func get_choice() -> TreeRes.Choice:
	var choice = TreeRes.Choice.new()
	choice.text = text_edit.text
	return choice

func on_edit():
	emit_signal("choice_edited")
