extends Control
class_name DialogPlayer, "res://addons/dialog_maker/icons/DialogPlay.svg"

signal request_next(choice)

onready var name_label: Label = $VBoxContainer/DialogContainer/VBoxContainer/NameLabel
onready var content: RichTextLabel = $VBoxContainer/DialogContainer/VBoxContainer/ContentLabel
onready var icon_rect: TextureRect = $VBoxContainer/DialogContainer/VBoxContainer/IconRect
onready var options_menu: PopupMenu = $VBoxContainer/VBoxContainer/OptionsMenu

onready var portraits: Array = [
	$"3Portraits/PortraitLeft",
	$"3Portraits/PortraitCenter",
	$"3Portraits/PortraitRight",
	$"4Portraits/Portrait1",
	$"4Portraits/Portrait2",
	$"4Portraits/Portrait3",
	$"4Portraits/Portrait4"
]

export var input_action: String
export var back_character_color: Color = Color.white

var current_dialog: Dictionary

func _ready():
	hide()
	for portra in portraits:
		portra.hide()

func _input(event: InputEvent):
	if Input.is_action_just_released(input_action):
		if !options_menu.visible:
			emit_signal("request_next", -1)

func display_secuence(dict: Dictionary):
	name_label.text = dict["name"]
	content.text = dict["content"]
	
	if dict.has("conditions") && !dict["conditions"][0]["meet"]:
		content.text = dict["conditions"][0]["display"]

func display_choice(dict: Dictionary):
	name_label.text = dict["name"]
	content.text = dict["content"]
	
	options_menu.clear()
	for choice in dict["choices"]:
		options_menu.add_item(choice)
	if dict.has("conditions"):
		var index: int = 0
		for cond in dict["conditions"]: #display, meet (bool)
			if cond == null: continue
			var choice_text: String = dict["choices"][index]
			options_menu.set_item_text( index, str(cond["display"], " ", choice_text) )
			options_menu.set_item_disabled(index, !cond["meet"])
			#options_menu.items[0].get_node("Label").name
			index += 1
	options_menu.popup_centered()

func display_portrait(texture: Texture, pos: int, flip: bool = false):
	var portrait: TextureRect = portraits[pos]
	var parent: Control = portrait.get_parent()
	
	for portra in portraits:
		portra = portra as TextureRect
		portra.self_modulate = back_character_color
	
	portrait.show()
	portrait.texture = texture
	portrait.flip_h = flip
	portrait.self_modulate = Color.white
	
	parent.move_child(portrait, parent.get_child_count()-1)

func _on_choice_button(index: int):
	emit_signal("request_next", index)

func _on_Dialog_dialog_started(dialog: Dictionary, ref):
	if visible: return
	
	icon_rect.grab_focus()
	
	connect("request_next", ref, "request_next")
	ref.connect("dialog_next", self, "_on_Dialog_dialog_next")
	ref.connect("dialog_ended", self, "_on_Dialog_dialog_ended")
	
	current_dialog = dialog
	
	match dialog["type"]:
		"Secuence": display_secuence(dialog)
		"Choice": display_choice(dialog)
	
	display_portrait(dialog["portrait"], dialog["pos"], dialog["flip"])
	
	show()

func _on_Dialog_dialog_next(dialog: Dictionary):
	current_dialog = dialog
	
	match dialog["type"]:
		"Secuence": display_secuence(dialog)
		"Choice": display_choice(dialog)
	
	display_portrait(dialog["portrait"], dialog["pos"], dialog["flip"])

func _on_Dialog_dialog_ended():
	for sig in get_signal_connection_list("request_next"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	
	hide()
