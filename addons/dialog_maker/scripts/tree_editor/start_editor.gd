tool
extends PanelContainer

const StartPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/StartPanel.tscn")

onready var panel_container: VBoxContainer = $VBoxContainer/ScrollContainer/PanelVBoxContainer

var characters: Array = []

var current_node: StartNode setget set_current_node
func set_current_node(node: StartNode):
	current_node = node
	if node == null:
		clear_panels()
		return
	
	load_data(node.start_data)

func connect_panel(panel: StartPanel):
	panel.delete_button.connect("pressed", self, "delete_panel", [panel])
	panel.connect("panel_edited", self, "on_edit_panel", [panel])

func clear_panels():
	for panel in panel_container.get_children():
#		connect_dialog(panel, true)
		panel.free()

func load_data(data_array: Array):
	if data_array.empty():
		clear_panels()
		return
	
	#free unnecessary dialogues
	if panel_container.get_child_count() > data_array.size():
		var diff: int = panel_container.get_child_count() - data_array.size()
		while diff > 0:
			var n: int = panel_container.get_child_count() - 1
			panel_container.get_child(n).free()
			diff -= 1
	
	var index: int = 0
	for data in data_array:
		#re use previous dialogues or add necessary
		if index + 1 <= panel_container.get_child_count():
			panel_container.get_child(index).load_start_data(characters, data)
			panel_container.get_child(index).index = index
		else:
			var start_panel: StartPanel = StartPanelScene.instance()
			panel_container.add_child(start_panel)
			start_panel.load_start_data(characters, data)
			
			connect_panel(start_panel)
			
			start_panel.index = index
		
		index += 1

func add_panel():
	var new_data: DialogMaker.StartData = DialogMaker.StartData.new()
	current_node.start_data.append(new_data)
	
	var new_panel: StartPanel = StartPanelScene.instance()
	panel_container.add_child(new_panel)
	new_panel.load_start_data(characters, new_data)
	
	new_data = new_panel.get_start_data()
	connect_panel(new_panel)
	
	new_panel.index = current_node.start_data.size() - 1
#	print(new_dialog_panel.index)
	current_node.display_data()

func delete_panel(dialog_panel: StartPanel):
	current_node.start_data.remove(dialog_panel.index)
	dialog_panel.queue_free()
	
	var index: int = 0
	for panel in panel_container.get_children():
		panel = panel as StartPanel
		if !panel.is_queued_for_deletion():
			panel.index = index
			index += 1
	
	current_node.display_secuence()

func move_panel(data_panel: StartPanel, new_index: int):
	var data = current_node.start_data[data_panel.index]
	current_node.start_data.remove(data_panel.index)
	current_node.start_data.insert(new_index, data)
	
	panel_container.move_child(data_panel, new_index)
	
	var index: int
	for panel in panel_container.get_children():
		panel.index = index
		index += 1
	
	if data_panel.index != new_index: print("ERROR, wrong index")
	
	current_node.display_data()

func on_edit_panel(panel: StartPanel):
	var data: DialogMaker.StartData = panel.get_start_data()
	current_node.start_data[panel.index] = data
	
	current_node.display_data(characters[data.chara_id].display_name)
	
func on_characters_change(active: bool, _characters: Array):
	characters = _characters
	for panel in panel_container.get_children():
		panel = panel as StartPanel
		panel.on_change_character(active, characters)
