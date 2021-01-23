tool
extends PanelContainer
class_name StartPanel

signal panel_edited

var index: int

var tree_res: TreeRes
var characters: Array

onready var portrait_button: Button = $VBoxContainer/HBoxContainer/PortraitButton
onready var portrait_grid: GridContainer = $VBoxContainer/PortraitGridContainer
onready var character_option: OptionButton = $VBoxContainer/HBoxContainer/VBoxContainer/CharacterOptionButton
onready var pos_option: OptionButton = $VBoxContainer/HBoxContainer/VBoxContainer/PositionOptionButton
onready var flip_check: CheckBox = $VBoxContainer/HBoxContainer/VBoxContainer/FlipCheckBox

onready var delete_button: Button = $VBoxContainer/HBoxContainer/DeleteButton

func _exit_tree():
	if Engine.editor_hint: return
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])
	
	for sig in get_signal_connection_list("panel_edited"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func load_start_data(_characters: Array, data: Dictionary) -> void:
	#print("load dialoge: ", dialog)
	characters = _characters
	
	character_option.clear()
	for chara in characters:
		chara = chara as CharacterRes
		character_option.add_item(chara.display_name)
	
	character_option.select( int(clamp(data["chara_id"], 0, character_option.get_item_count() - 1 )) )
	
	pos_option.select(data["pos"])
	flip_check.pressed = data["flip"]
	
	if data["portrait"]: portrait_button.icon = data["portrait"]
	elif characters[data["chara_id"]].portraits.size() != 0: 
		portrait_button.icon = characters[data["chara_id"]].portraits[0]
	
	update_portrait_grid(characters[data["chara_id"]])

func load_settings(settings: Dictionary) -> void:
	pos_option.select(settings["pos"])
	flip_check.pressed = settings["flip"]
	
	if settings["portrait"]: portrait_button.icon = settings["portrait"]
	elif characters[character_option.selected].portraits.size() != 0: 
		portrait_button.icon = characters[character_option.selected].portraits[0]
	
	update()
	print("load_settings")

func load_settings_from_res() -> void:
	var settings: Dictionary = tree_res.character_settings[character_option.selected]
	load_settings(settings)

func get_panel_data() -> Dictionary:
	var dict: Dictionary = {
		"chara_id": character_option.selected, 
		"portrait": portrait_button.icon,
		"pos": pos_option.selected,
		"flip": flip_check.pressed
	}

	return dict

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
	emit_signal("panel_edited")
	
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

func _on_PortraitButton_pressed():
	portrait_grid.visible = !portrait_grid.visible
	$VBoxContainer/HSeparator.visible = portrait_grid.visible

func _on_CharacterOptionButton_item_selected(index):
	update_portrait_grid(characters[index])
	
	load_settings(tree_res.character_settings[index])
	
#	if characters[index].portraits.size() != 0: 
#		portrait_button.icon = characters[index].portraits[0]
#	else: portrait_button.icon = null
	
	emit_signal("panel_edited")

func _on_portrait_selector_button_pressed(texture: Texture):
	portrait_button.icon = texture
	portrait_grid.hide()
	$VBoxContainer/HSeparator.hide()
	on_edit()
