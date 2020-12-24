tool
extends PanelContainer
class_name DialoguePanel

signal dialogue_edited

var index: int

onready var text_edit: TextEdit = $VBoxContainer/TextEdit
onready var character_option: OptionButton = $VBoxContainer/OptionsPanelContainer/HBoxContainer/CharacterOptionButton
onready var delete_button: Button = $VBoxContainer/OptionsPanelContainer/HBoxContainer/DeleteButton

func _exit_tree():
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])
	
	for sig in get_signal_connection_list("dialogue_edited"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func load_dialogue(characters: Array, dialog: Dictionary) -> void:
	character_option.clear()
	for chara in characters:
		chara = chara as CharacterRes
		character_option.add_item(chara.display_name)
	
	text_edit.text = dialog["text"]
	
	character_option.select( int(clamp(dialog["chara_id"], 0, character_option.get_item_count() - 1 )) )
	

func get_dialogue() -> Dictionary:
	var dialog: Dictionary = {
		"chara_id": character_option.selected, 
		"text": text_edit.text
	}
	
#	print("[" + String(dialog.character_id) + "] " + dialog.text)
	return dialog

func on_edit(_option_id: int = -1):
	emit_signal("dialogue_edited")

func on_change_character(active: bool, characters: Array):
	var select: int = character_option.selected
	
	character_option.clear()
	for chara in characters:
		chara = chara as CharacterRes
		character_option.add_item(chara.display_name)
	
	if active:
		character_option.select(select)
	else:
		character_option.select( int(clamp(select, 0, character_option.get_item_count() - 1 )) )
#		for chara_index in character_option.get_item_count():
#			var chara_name = character_option.items[chara_index].text
#			if chara_name == character.display_name:
#				character_option.remove_item(chara_index)
