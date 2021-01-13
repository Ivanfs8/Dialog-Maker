tool
extends PanelContainer

var undo_redo: UndoRedo

var tree_resource: TreeRes = null setget set_tree_resource
func set_tree_resource(tree: TreeRes):
	if tree == null:
		return
	
	tree_graph.clear_all_nodes()
	tree_resource = tree
	
#	if tree.characters.empty():
#		invalid_tree_resource("Please add characters to the resource")
#		return
	
	tree_graph.load_resource(tree_resource)
	
	properties_tab.set_tree_resource(tree_resource)
	character_tab.set_tree_resource(tree_resource)
	
	$Label.hide()
	$HSplitContainer.show()
	
	tree_resource.test()

onready var tree_graph: GraphEdit = $HSplitContainer/TreeVBoxContainer/TreeGraphEdit
#onready var secuence_editor = $HSplitContainer/HBoxContainer/SecuenceEditor
#onready var choice_editor = $HSplitContainer/HBoxContainer/ChoiceEditor
#onready var condition_editor = $HSplitContainer/HBoxContainer/ConditionEditor

onready var settings_tabs: TabContainer = $HSplitContainer/SettingsTabContainer
onready var character_tab: VBoxContainer = $HSplitContainer/SettingsTabContainer/Characters
onready var properties_tab: VBoxContainer = $HSplitContainer/SettingsTabContainer/Properties

func _ready():
	invalid_tree_resource()
	
	settings_tabs.hide()

func invalid_tree_resource(text: String = "Please select a dialogue resource"):
	$Label.text = text
	$Label.show()
	$HSplitContainer.hide()

func save_resource():
	if tree_resource != null:
		tree_graph.save_resource(tree_resource)
		
#		var tree_data: TreeData = TreeData.new(tree_resource)
#		tree_resource.tree_data = tree_data.make_tree_data()
#		tree_resource.take_over_path(tree_resource.resource_path)
		
		var err := ResourceSaver.save(tree_resource.resource_path, tree_resource)
		if err == OK: print("Saved " + tree_resource.resource_name + " succesfully")
		else: print(err)

class TreeData:
	var nodes_data: Array
	var connections: Array
	var tree_data: Dictionary = {}
	
	func _init(tree: TreeRes):
		nodes_data = tree.nodes_data
		connections = tree.connections
	
	func make_tree_data() -> Dictionary:
		if nodes_data.empty(): return {}
		
		var queue_conditions: Array = []
		
		var index: int = 0
		for node in nodes_data:
			node = node as DgTreeNode.SaveData
			match node.type:
				"StartNode": node["next"] = get_next(node["name"])
				"SecuenceNode": node["next"] = get_next(node["name"])
				"ChoiceNode": node["paths"] = get_paths(node)
				"ConditionNode": 
					node["affects"] = get_affects(node)
					node["index"] = index
					queue_conditions.append(node)
			
			tree_data[index] = node
			index += 1
		
		for cond_node in queue_conditions:
			for data in cond_node["affects"]:
				tree_data[data["id"]]["conditions"] = []
			for data in cond_node["affects"]:
				tree_data[data["id"]]["conditions"].append({
					"id": cond_node["index"],
					"port": data["port"]
				})
			cond_node.erase("index")
		
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
	
	func get_affects(node: Dictionary) -> Array:
		var affects: Array
		
		for c in connections:
			if c["from"] == node["name"]:
				affects.append({
					"id": get_index_of_node(c["to"]),
					"port": c["to_port"]
				})
		
		return affects
	
	func get_index_of_node(name: String) -> int:
		var index : int = 0
		for node in nodes_data:
			if node["name"] == name:
				return index
			
			index += 1
		return -1

func _on_SettingsButton_toggled(button_pressed):
	if button_pressed:
		settings_tabs.show()
	else:
		settings_tabs.hide()
