tool
extends PanelContainer
class_name DialoguePanel

signal dialogue_edited

var index: int

onready var text_edit: TextEdit = $VBoxContainer/TextEdit
onready var character_option: OptionButton = $VBoxContainer/OptionsPanelContainer/HBoxContainer/CharacterOptionButton
onready var delete_button: Button = $VBoxContainer/OptionsPanelContainer/HBoxContainer/DeleteButton

func load_dialogue(characters: Array, dialog: Dictionary) -> void:
	character_option.clear()
	for chara in characters:
		character_option.add_item(chara)
	
	text_edit.text = dialog["text"]
	character_option.select(dialog["chara_id"])

func get_dialogue() -> Dictionary:
	var dialog: Dictionary = {
		"chara_id": character_option.selected, 
		"text": text_edit.text
	}
	
#	print("[" + String(dialog.character_id) + "] " + dialog.text)
	return dialog

func on_edit(_option_id: int = -1):
	emit_signal("dialogue_edited")
