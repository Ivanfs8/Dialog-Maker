extends Control
class_name DialogPlayer, "res://addons/dialog_maker/icons/DialogPlay.svg"

signal request_next(choice)

onready var name_label: Label = $VBoxContainer/DialogContainer/VBoxContainer/NameLabel
onready var content: RichTextLabel = $VBoxContainer/DialogContainer/VBoxContainer/ContentLabel
onready var icon_rect: TextureRect = $VBoxContainer/DialogContainer/VBoxContainer/IconRect
onready var options_menu: PopupMenu = $VBoxContainer/VBoxContainer/OptionsMenu

export var input_action: String

var current_dialog: Dictionary

func _ready():
	hide()

func _input(event: InputEvent):
	if Input.is_action_just_released(input_action):
		if !options_menu.visible:
			emit_signal("request_next", -1)

func display_secuence(dict: Dictionary):
	name_label.text = dict["name"]
	content.text = dict["content"]

func display_choice(dict: Dictionary):
	name_label.text = dict["name"]
	content.text = dict["content"]
	options_menu.clear()
	for choice in dict["choices"]:
		options_menu.add_item(choice)
	options_menu.popup_centered()

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
	
	show()

func _on_Dialog_dialog_next(dialog: Dictionary):
	current_dialog = dialog
	
	match dialog["type"]:
		"Secuence": display_secuence(dialog)
		"Choice": display_choice(dialog)

func _on_Dialog_dialog_ended():
	for sig in get_signal_connection_list("request_next"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	
	hide()
