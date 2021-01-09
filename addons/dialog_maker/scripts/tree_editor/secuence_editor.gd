tool
extends PanelContainer

const DialoguePanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/DialoguePanel.tscn")

onready var dialogues_cont: VBoxContainer = $VBoxContainer/ScrollContainer/DialoguesVBoxContainer

var characters: Array = []

var current_node: SecuenceNode = null setget set_current_node
func set_current_node(node: SecuenceNode):
	current_node = node
	
	if node == null:
		clear_secuence()
		return
	
	load_secuence(node.secuence)

func connect_dialog(dialog_panel: DialoguePanel):
	dialog_panel.delete_button.connect("pressed", self, "delete_dialogue", [dialog_panel])
	dialog_panel.connect("dialogue_edited", self, "on_edit_dialogue", [dialog_panel])

func clear_secuence():
	for panel in dialogues_cont.get_children():
#		connect_dialog(panel, true)
		panel.free()

func load_secuence(secuence: Array):
	if secuence.empty():
		clear_secuence()
		return
	
	#free unnecessary dialogues
	if dialogues_cont.get_child_count() > secuence.size():
		var diff: int = dialogues_cont.get_child_count() - secuence.size()
		while diff > 0:
			var n: int = dialogues_cont.get_child_count() - 1
#			connect_dialog( dialogues_cont.get_child(n), true )
			dialogues_cont.get_child(n).free()
			diff -= 1
	
	var index: int = 0
	for dialog in secuence:
		#re use previous dialogues or add necessary
		if index + 1 <= dialogues_cont.get_child_count():
			dialogues_cont.get_child(index).load_dialogue(characters, dialog)
			dialogues_cont.get_child(index).index = index
		else:
			var dialog_panel: DialoguePanel = DialoguePanelScene.instance()
			dialogues_cont.add_child(dialog_panel)
			dialog_panel.load_dialogue(characters, dialog)
			
			connect_dialog(dialog_panel)
			
			dialog_panel.index = index
		
		index += 1

func add_dialogue():
	var new_dialog: Dictionary = TreeRes.DIALOGUE
	current_node.secuence.append(new_dialog)
	
	var new_dialog_panel: DialoguePanel = DialoguePanelScene.instance()
	dialogues_cont.add_child(new_dialog_panel)
	new_dialog_panel.load_dialogue(characters, new_dialog)
	
	connect_dialog(new_dialog_panel)
	
	new_dialog_panel.index = current_node.secuence.size() - 1
#	print(new_dialog_panel.index)
	current_node.display_secuence()

func delete_dialogue(dialog_panel: DialoguePanel):
	current_node.secuence.remove(dialog_panel.index)
	dialog_panel.queue_free()
	
	var index: int = 0
	for panel in dialogues_cont.get_children():
		panel = panel as DialoguePanel
		if !panel.is_queued_for_deletion():
			panel.index = index
			index += 1
	
	current_node.display_secuence()

func move_dialogue(dialog_panel: DialoguePanel, new_index: int):
	var dialog = current_node.secuence[dialog_panel.index]
	current_node.secuence.remove(dialog_panel.index)
	current_node.secuence.insert(new_index, dialog)
	
	dialogues_cont.move_child(dialog_panel, new_index)
	
	var index: int
	for panel in dialogues_cont.get_children():
		panel.index = index
		index += 1
	
	if dialog_panel.index != new_index: print("ERROR, wrong index")
	
	current_node.display_secuence()

func on_edit_dialogue(dialog_panel: DialoguePanel):
	var dialog: Dictionary = dialog_panel.get_dialogue()
	current_node.secuence[dialog_panel.index] = dialog
	
	current_node.display_secuence(characters[ dialog["chara_id"] ].display_name)
	
func on_characters_change(active: bool, _characters: Array):
	characters = _characters
	for panel in dialogues_cont.get_children():
		panel = panel as DialoguePanel
		panel.on_change_character(active, characters)
