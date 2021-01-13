tool
extends GraphEdit

#Nodes
const StartNodeScene: PackedScene = preload("res://addons/dialog_maker/scenes/graph_nodes/StartNode.tscn")
const SecuenceNodeScene: PackedScene = preload("res://addons/dialog_maker/scenes/graph_nodes/SecuenceNode.tscn")
const ChoiceNodeScene: PackedScene = preload("res://addons/dialog_maker/scenes/graph_nodes/ChoiceNode.tscn")
const ConditionNodeScene: PackedScene = preload("res://addons/dialog_maker/scenes/graph_nodes/ConditionNode.tscn")

onready var popup_menu: PopupMenu = $PopupMenu
var auto_connect: Dictionary = {}

#graphedit does all the signals connections for selected node automatically, 
#even thou the rest of the graphnode signals have to be set manually :/

#var selected_node: GraphNode = null
#func _graph_node_raised(node: Node):
#	set_selected(node)
#	selected_node = node

func _ready():
	remove_valid_connection_type(0,1)
	remove_valid_connection_type(1,0)

func _exit_tree():
	if Engine.editor_hint: return
	for sig in get_signal_connection_list("node_selected"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func get_nodes() -> Array:
	var nodes: Array = []
	for node in get_children():
		if node is GraphNode: nodes.append(node)
	return nodes

func connect_graph_node(node: GraphNode):
#	node.connect("raise_request", self, "_graph_node_raised")
	node.connect("resize_request", self, "_on_node_resize", [node])
	node.connect("close_request", self, "_on_node_close", [node])

func save_resource(res: TreeRes):
	res.nodes_data.clear()
	res.nodes_data.append(get_node("StartNode").get_save_data())
	for node in get_nodes():
		node = node as DgTreeNode
		if node.name == "StartNode": continue
		res.nodes_data.append(node.get_save_data())
	
	res.connections.clear()
	res.connections = get_connection_list()

func load_resource(tree: TreeRes):
	if tree.nodes_data.empty():
		add_node("Start")
	else:
		#load all saved nodes
		for node_data in tree.nodes_data:
			var node: DgTreeNode = add_node(node_data.type)
			node.load_save_data(node_data)
	
	#load all saved connections
	if !tree.connections.empty():
		for c in tree.connections:
			connect_node(c.from, c.from_port, c.to, c.to_port)

func add_node(type: String, pos: Vector2 = rect_size * 0.5 + scroll_offset):
	var new_node: DgTreeNode
	
	match type:
		"Start", "StartNode": new_node = StartNodeScene.instance()
		"Secuence", "SecuenceNode": new_node = SecuenceNodeScene.instance()
		"Choice", "ChoiceNode": new_node = ChoiceNodeScene.instance()
		"Condition", "ConditionNode": new_node = ConditionNodeScene.instance()
	
	if new_node != null:
		add_child(new_node)
		connect_graph_node(new_node)
		
		new_node.offset = pos
	
	return new_node

#Clear Graph
func clear_all_nodes():
	clear_connections()
	for node in get_nodes():
#		node = node as GraphNode
		node.free()

# removes connections going from an id
func remove_connection(id, node):
	for i in get_connection_list():
		if i.from == node.name and i.from_port == id:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)

# used to remove all connections going in or out of a node
func remove_all_connections(node: GraphNode):
	for i in get_connection_list():
		if i.from == node.name or i.to == node.name:
			disconnect_node(i.from, i.from_port, i.to, i.to_port)

func _on_node_resize(newSize: Vector2, ref: GraphNode):
	ref.rect_size = newSize

func _on_node_close(ref: GraphNode):
	remove_all_connections(ref)
	ref.queue_free()

func _on_TreeGraphEdit_connection_request(from, from_slot, to, to_slot):
	#assure there's only one connection per slot, if true overwrite with new connection
	# c = {from_port: 0, from: "GraphNode name 0", to_port: 1, to: "GraphNode name 1" }
	var slot_connections = []
	for c in get_connection_list():
		if c["from"] == from and c["from_port"] == from_slot:
			slot_connections.append(c)
	for c in slot_connections:
		disconnect_node(c["from"], c["from_port"], c["to"], c["to_port"])
	
	connect_node(from, from_slot, to, to_slot)

func _on_TreeGraphEdit_disconnection_request(from, from_slot, to, to_slot):
	disconnect_node(from, from_slot, to, to_slot)

func _on_TreeGraphEdit_popup_request(position: Vector2):
	popup_menu.rect_global_position = position
	popup_menu.popup()

func _on_PopupMenu_id_pressed(id: int):
	var new_node: DgTreeNode
	match id:
		0: new_node = add_node("Secuence", get_local_mouse_position() + scroll_offset)
		1: new_node = add_node("Choice", get_local_mouse_position() + scroll_offset)
		2: new_node = add_node("Condition", get_local_mouse_position() + scroll_offset)
	
	if !auto_connect.empty() && id != 2:
		_on_TreeGraphEdit_connection_request(auto_connect["from"], auto_connect["from_slot"], new_node.name, 0)
		auto_connect = {}

func _on_TreeGraphEdit_connection_to_empty(from: String, from_slot: int, release_position: Vector2):
	auto_connect = {"from": from, "from_slot": from_slot}
	popup_menu.rect_global_position = get_global_mouse_position()
	popup_menu.popup()

func _on_PopupMenu_popup_hide():
	auto_connect = {}
