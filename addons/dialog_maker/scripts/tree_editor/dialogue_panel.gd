tool
extends PanelContainer
class_name DialoguePanel

signal dialogue_edited

var index: int

var characters: Array

onready var text_edit: TextEdit = $VBoxContainer/HBoxContainer/TextEdit
onready var character_option: OptionButton = $VBoxContainer/OptionsPanelContainer/HBoxContainer/CharacterOptionButton
onready var delete_button: Button = $VBoxContainer/OptionsPanelContainer/HBoxContainer/DeleteButton

onready var pos_option: OptionButton = $VBoxContainer/OptionsPanelContainer/HBoxContainer/PositionOptionButton
onready var flip_check: CheckBox = $VBoxContainer/OptionsPanelContainer/HBoxContainer/FlipCheckBox
onready var portrait_button: Button = $VBoxContainer/HBoxContainer/PortraitButton
onready var portrait_grid: GridContainer = $VBoxContainer/PortraitGridContainer

func _exit_tree():
	if Engine.editor_hint: return
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])
	
	for sig in get_signal_connection_list("dialogue_edited"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func load_dialogue(_characters: Array, dialog: DialogMaker.Dialogue) -> void:
	#print("load dialoge: ", dialog)
	characters = _characters
	
	character_option.clear()
	for chara in characters:
		chara = chara as CharacterRes
		character_option.add_item(chara.display_name)
	
	text_edit.text = dialog.text
	
	character_option.select( int(clamp(dialog.chara_id, 0, character_option.get_item_count() - 1 )) )
	
	pos_option.select(dialog.pos)
	flip_check.pressed = dialog.flip
	
	if dialog.portrait: portrait_button.icon = dialog.portrait
	elif characters[dialog.chara_id].portraits.size() != 0: 
		portrait_button.icon = characters[dialog.chara_id].portraits[0]
	
	update_portrait_grid(characters[dialog.chara_id])

func get_dialogue() -> DialogMaker.Dialogue:
	return DialogMaker.Dialogue.new(
		character_option.selected,
		text_edit.text,
		portrait_button.icon,
		pos_option.selected,
		flip_check.pressed
	)

func update_portrait_grid(character: CharacterRes):
	for child in portrait_grid.get_children(): child.queue_free()
	for portra in character.portraits:
		var portra_button: Button = Button.new()
		portrait_grid.add_child(portra_button)
		portra_button.text = ""
		portra_button.icon = portra
		portra_button.expand_icon = true
		portra_button.rect_min_size = Vector2(64,64)
		portra_button.connect("pressed", self, "_on_portrait_selector_button_pressed", [portra])

func on_edit(_option_id: int = -1):
	emit_signal("dialogue_edited")

#active = false: a character was removed
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

func _on_PortraitButton_pressed():
	portrait_grid.visible = !portrait_grid.visible
	$VBoxContainer/HSeparator.visible = portrait_grid.visible

func _on_CharacterOptionButton_item_selected(index):
	update_portrait_grid(characters[index])
	if characters[index].portraits.size() != 0: 
		portrait_button.icon = characters[index].portraits[0]
	else: portrait_button.icon = null

func _on_portrait_selector_button_pressed(texture: Texture):
	portrait_button.icon = texture
	portrait_grid.hide()
	$VBoxContainer/HSeparator.hide()
	on_edit()
