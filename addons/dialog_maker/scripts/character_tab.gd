tool
extends Control

const CharaButton: Script = preload("res://addons/dialog_maker/scripts/character_button.gd")

signal character_changed

onready var search_line: LineEdit = $SearchLineEdit
onready var characters_cont: VBoxContainer = $CharactersVBoxContainer

var tree_resource: TreeRes

var all_characters: Array = []
var display_characters: Array = []

func set_tree_resource(tree: TreeRes):
	tree_resource = tree
	
	if all_characters.empty():
		all_characters = ResFileFinder.get_files("res://dialog_maker_resources/characters/", CharacterRes)
		
		for chara in all_characters:
			chara = chara as CharacterRes
			var chara_button: CharaButton = CharaButton.new()
			chara_button.name = chara.display_name
			chara_button.text = chara.display_name
			
			if tree_resource.characters.find(chara) != -1:
				chara_button.pressed = true
			
			characters_cont.add_child(chara_button)
#			chara_button.parent_ref = self
			chara_button.connect("toggled", self, "_on_chara_button_toggled", [chara])
	
	display_characters = all_characters.duplicate()

func _exit_tree():
	if Engine.editor_hint: return
	for sig in get_signal_connection_list("character_changed"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func _on_chara_button_toggled(toggle: bool, character: CharacterRes):
	if !tree_resource:
		return
	
	if toggle:
		tree_resource.characters.append(character)
	else:
		if tree_resource.characters.size() <= 1:
			var button: CharaButton = characters_cont.get_node(character.display_name)
			button.disconnect("toggled", self, "_on_chara_button_toggled")
			button.pressed = true #recursive?
			button.connect("toggled", self, "_on_chara_button_toggled", [character])
			return
		
		var index: int = tree_resource.characters.find(character)
		if index != -1:
			tree_resource.characters.remove(index)
			
	emit_signal("character_changed", toggle, tree_resource.characters)
