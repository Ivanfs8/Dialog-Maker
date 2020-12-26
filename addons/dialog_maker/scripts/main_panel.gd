tool
extends PanelContainer

const ForcePreload = {
	"TreeRes": preload("res://addons/dialog_maker/scripts/tree_res.gd"),
	"TreeNode": preload("res://addons/dialog_maker/scripts/graph_nodes/node_base.gd"),
	"StartNode": preload("res://addons/dialog_maker/scripts/graph_nodes/start_node.gd"),
	"SecuenceNode": preload("res://addons/dialog_maker/scripts/graph_nodes/secuence_node.gd"),
	"ChoiceNode": preload("res://addons/dialog_maker/scripts/graph_nodes/choice_node.gd"),
	"SecuenceEditor": preload("res://addons/dialog_maker/scripts/graph_nodes/secuence_node.gd"),
	"DialoguePanel": preload("res://addons/dialog_maker/scripts/tree_editor/dialogue_panel.gd"),
	"ChoiceEditor": preload("res://addons/dialog_maker/scripts/tree_editor/choice_editor.gd"),
	"ChoicePanel": preload("res://addons/dialog_maker/scripts/tree_editor/choice_panel.gd")
}

var undo_redo: UndoRedo

var tree_resource: TreeRes = null setget set_tree_resource
func set_tree_resource(tree: TreeRes):
	if tree == null:
		return
	
	tree_graph.clear_all_nodes()
	tree_resource = tree
	
	if tree.characters.empty():
		invalid_tree_resource("Please add characters to the resource")
		return
	
	tree_graph.load_resource(tree_resource)
	
	secuence_editor.characters = tree_resource.characters
	choice_editor.characters = tree_resource.characters
	
	character_tab.set_tree_resource(tree_resource)
	
	$Label.hide()
	$HSplitContainer.show()

onready var tree_graph: GraphEdit = $HSplitContainer/TreeVBoxContainer/TreeGraphEdit
onready var secuence_editor = $HSplitContainer/HBoxContainer/SecuenceEditor
onready var choice_editor = $HSplitContainer/HBoxContainer/ChoiceEditor

onready var settings_tabs: TabContainer = $HSplitContainer/SettingsTabContainer
onready var character_tab: VBoxContainer = $HSplitContainer/SettingsTabContainer/Characters

func _ready():
	invalid_tree_resource()
	secuence_editor.hide()
	choice_editor.hide()
	
	settings_tabs.hide()
	
	character_tab.connect("character_changed", secuence_editor, "on_characters_change")
	character_tab.connect("character_changed", choice_editor, "on_characters_change")

func invalid_tree_resource(text: String = "Please select a dialogue resource"):
	$Label.text = text
	$Label.show()
	$HSplitContainer.hide()

func save_resource():
	if tree_resource != null:
		if secuence_editor.current_node != null:
			secuence_editor.current_node.display_secuence()
		if choice_editor.current_node != null:
			choice_editor.current_node.display_choices()
		
		tree_graph.save_resource(tree_resource)
		
		var tree_data: TreeData = TreeData.new(tree_resource)
		tree_resource.tree_data = tree_data.make_tree_data()
#		tree_resource.take_over_path(tree_resource.resource_path)
		
		var err := ResourceSaver.save(tree_resource.resource_path, tree_resource)
		if err == OK: print("Saved " + tree_resource.resource_name + " succesfully")
		else: print(err)

func _on_TreeGraphEdit_node_selected(node: TreeNode):
	settings_tabs.hide()
	
	secuence_editor.hide()
	secuence_editor.current_node = null
	choice_editor.hide()
	choice_editor.current_node = null
	
#	character_tab.characters = tree_resource.characters
	match node.get_class():
		"SecuenceNode": 
			secuence_editor.characters = tree_resource.characters
			secuence_editor.set_current_node(node)
			secuence_editor.show()
		"ChoiceNode":
			choice_editor.characters = tree_resource.characters
			choice_editor.set_current_node(node)
			choice_editor.show()

class TreeData:
	var nodes_data: Array
	var connections: Array
	var tree_data: Dictionary = {}
	
	func _init(tree: TreeRes):
		nodes_data = tree.nodes_data
		connections = tree.connections
	
	func make_tree_data() -> Dictionary:
		if nodes_data.empty():
			return {}
		
		var index: int = 0
		for node in nodes_data:
			match node["type"]:
				"SecuenceNode", "StartNode": node["next"] = get_next(node["name"])
				"ChoiceNode": node["paths"] = get_paths(node)
			
			tree_data[index] = node
			index += 1
		
		return tree_data

	func get_next(name: String) -> int:
		for c in connections:
			if c["from"] == name: return get_index_of_node(c["to"])
		
		return -1

	func get_paths(node: Dictionary) -> Array:
		var paths: Array
		for choice in node["choices"]:
			paths.append(-1)
		
	#	var i: int = 0
		for c in connections:
			if c["from"] == node["name"]:
				paths[c["from_port"]] = get_index_of_node(c["to"])
			
	#		i += 1
		
		return paths

	func get_index_of_node(name: String) -> int:
		var index : int = 0
		for node in nodes_data:
			if node["name"] == name:
				return index
			
			index += 1
		return -1

func _on_SettingsButton_toggled(button_pressed):
	if button_pressed:
		secuence_editor.hide()
		secuence_editor.current_node = null
		choice_editor.hide()
		choice_editor.current_node = null
		
		settings_tabs.show()
	else:
		settings_tabs.hide()
