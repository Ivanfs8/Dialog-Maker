tool
extends GraphNode
class_name DgTreeNode

func get_class(): return "TreeNode"

class SaveData:
	var type: String
	var name: String
	var offset: Vector2
	var size: Vector2
	
	func _init(_type: String = "", _name: String = "", _offset: Vector2 = Vector2.ZERO, _size: Vector2 = Vector2.ONE):
		type = _type
		name = _name
		offset = _offset
		size = _size
	
	func load_save_data(save_data: SaveData):
		type = save_data.type
		name = save_data.name
		offset = save_data.offset
		size = save_data.size
	
	func get_as_save_data() -> SaveData:
		return SaveData.new(type, name, offset, size)

func _exit_tree():
	if Engine.editor_hint: return
	for sig in get_signal_connection_list("resize_request"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("close_request"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func get_save_data():
	return SaveData.new(get_class(), name, offset, rect_size)

func load_save_data(save_data):
	name = save_data.name
	offset = save_data.offset
	rect_size = save_data.size

func get_labels() -> Array:
	var labels: Array = []
	for node in get_children():
		if node is Label: labels.append(node)
	
	return labels
