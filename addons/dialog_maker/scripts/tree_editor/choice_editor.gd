tool
extends PanelContainer

const ChoicePanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/ChoicePanel.tscn")

var characters: Array = []

onready var question_panel: DialoguePanel = $VBoxContainer/DialoguePanel
onready var choices_cont: VBoxContainer = $VBoxContainer/ScrollContainer/ChoicesVBoxContainer

func _ready(): question_panel.delete_button.hide()

var current_node: ChoiceNode = null setget set_current_node
func set_current_node(node: ChoiceNode):
	current_node = node
	
	if node == null:
		clear_choices()
		return
	
	load_choices(node.question, node.choices)

func connect_choice(choice_panel: ChoicePanel):
	choice_panel.delete_button.connect("pressed", self, "delete_choice", [choice_panel])
	choice_panel.connect("choice_edited", self, "on_edit_choice", [choice_panel])

func clear_choices():
	for panel in choices_cont.get_children():
		panel.free()

func load_choices(question: DialogMaker.Dialogue, choices: PoolStringArray):
	#load question
	question_panel.disconnect("dialogue_edited", self, "on_edit_question")
	question_panel.load_dialogue(characters, question)
	current_node.question = question_panel.get_dialogue()
	question_panel.connect("dialogue_edited", self, "on_edit_question")
	
	if choices.empty():
		clear_choices()
		return
	
	#free unnecessary choices
	if choices_cont.get_child_count() > choices.size():
		var diff: int = choices_cont.get_child_count() - choices.size()
		while diff > 0:
			var n: int = choices_cont.get_child_count() - 1
#			connect_choice( choices_cont.get_child(n), true )
			choices_cont.get_child(n).free()
			diff -= 1
	
	var index: int = 0
	for choice in choices:
		#re use previous choices or add necessary
		if index + 1 <= choices_cont.get_child_count():
			choices_cont.get_child(index).load_choice(choice)
			choices_cont.get_child(index).index = index
		else:
			var choice_panel: ChoicePanel = ChoicePanelScene.instance()
			choices_cont.add_child(choice_panel)
			choice_panel.load_choice(choice)
			
			connect_choice(choice_panel)
			
			choice_panel.index = index
		
		index += 1

func add_choice():
	var new_choice: String = ""
	current_node.choices.append(new_choice)
	
	var new_choice_panel: ChoicePanel = ChoicePanelScene.instance()
	choices_cont.add_child(new_choice_panel)
	new_choice_panel.load_choice(new_choice)
	
	connect_choice(new_choice_panel)
	
	new_choice_panel.index = current_node.choices.size() - 1
#	print(new_choice_panel.index)
	current_node.display_choices()

func delete_choice(choice_panel: ChoicePanel):
	current_node.choice.remove(choice_panel.index)
	choice_panel.queue_free()
	
	var index: int = 0
	for panel in choices_cont.get_children():
		panel = panel as DialoguePanel
		if !panel.is_queued_for_deletion():
			panel.index = index
			index += 1
	
	current_node.display_choices()

func move_choice(choice_panel: ChoicePanel, new_index: int):
	var choice: String = current_node.choices[choice_panel.index]
	current_node.choices.remove(choice_panel.index)
	current_node.choices.insert(new_index, choice)
	
	choices_cont.move_child(choice_panel, new_index)
	
	var index: int
	for panel in choices_cont.get_children():
		panel.index = index
		index += 1
	
	if choice_panel.index != new_index: print("ERROR, wrong index")
	
	current_node.display_choices()

func on_edit_choice(choice_panel: ChoicePanel):
	current_node.choices[choice_panel.index] = choice_panel.get_choice()
	
	current_node.display_choices()

func on_edit_question():
	current_node.question = question_panel.get_dialogue()
	
	current_node.display_choices(true)

func on_characters_change(active: bool, _characters: Array):
	characters = _characters
	question_panel.on_change_character(active, characters)
