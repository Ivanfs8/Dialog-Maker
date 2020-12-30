tool
extends PanelContainer

const ConditionalPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/ConditionPanel.tscn")

var properties: Dictionary

onready var conditional_cont: VBoxContainer = $VBoxContainer/ScrollContainer/ConditionsVBoxContainer

var current_node: ConditionNode = null setget set_current_node
func set_current_node(node: ConditionNode):
	current_node = node
	
	if node == null:
		clear_conditions()
		return
	
	load_conditions(node.conditions)

func connect_condition(condition_panel: ConditionPanel):
	condition_panel.delete_button.connect("pressed", self, "delete_condition", [condition_panel])
	condition_panel.connect("condition_edited", self, "on_edit_condition", [condition_panel])

func clear_conditions():
	for panel in conditional_cont.get_children():
		panel.free()

func load_conditions(conditions: Array):
	if conditions.empty():
		clear_conditions()
		return
	
	#free unnecessary dialogues
	if conditional_cont.get_child_count() > conditions.size():
		var diff: int = conditional_cont.get_child_count() - conditions.size()
		while diff > 0:
			var n: int = conditional_cont.get_child_count() - 1
			conditional_cont.get_child(n).free()
			diff -= 1
	
	var index: int = 0
	for cond in conditions:
		#re use previous dialogues or add necessary
		if index + 1 <= conditional_cont.get_child_count():
			conditional_cont.get_child(index).load_condition(properties, cond)
			conditional_cont.get_child(index).index = index
		else:
			var cond_panel: ConditionPanel = ConditionalPanelScene.instance()
			conditional_cont.add_child(cond_panel)
			cond_panel.load_condition(properties, cond)
			
			connect_condition(cond_panel)
			
			cond_panel.index = index
		
		index += 1

func add_condition():
	var new_condition: Dictionary = TreeRes.CONDITION
	current_node.conditions.append(new_condition)
	
	var new_condition_panel: ConditionPanel = ConditionalPanelScene.instance()
	conditional_cont.add_child(new_condition_panel)
	new_condition_panel.load_condition(properties, new_condition)
	
	connect_condition(new_condition_panel)
	
	new_condition_panel.index = current_node.conditions.size() - 1
#	print(new_condition_panel.index)
	current_node.display_condition()

func delete_condition(cond_panel: ConditionPanel):
	current_node.conditions.remove(cond_panel.index)
	cond_panel.queue_free()
	
	var index: int = 0
	for panel in conditional_cont.get_children():
		panel = panel as ConditionPanel
		if !panel.is_queued_for_deletion():
			panel.index = index
			index += 1
	
	current_node.display_condition()

func move_condition(cond_panel: ConditionPanel, new_index: int):
	var condition: Dictionary = current_node.conditions[cond_panel.index]
	current_node.conditions.remove(cond_panel.index)
	current_node.conditions.insert(new_index, condition)
	
	conditional_cont.move_child(cond_panel, new_index)
	
	var index: int
	for panel in conditional_cont.get_children():
		panel.index = index
		index += 1
	
	if cond_panel.index != new_index: print("ERROR, wrong index")
	
	current_node.display_condition()

func on_edit_condition(cond_panel: ConditionPanel):
	current_node.conditions[cond_panel.index] = cond_panel.get_condition()
	
	current_node.display_condition()
	
func on_properties_change(active: bool, _properties: Dictionary):
	properties = _properties
	for panel in conditional_cont.get_children():
		panel = panel as ConditionPanel
		panel.on_change_properties(active, _properties)
