tool
extends GraphNode
class_name TreeNode

func get_class(): return "TreeNode"

func _exit_tree():
#	for sig in get_signal_connection_list("raise_request"):
#		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("resize_request"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in get_signal_connection_list("close_request"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func get_save_data() -> Dictionary:
	var data: Dictionary = {
		"type": get_class(),
		"name": name,
		"offset": offset,
		"size": rect_size
	}
	
	return data

func load_save_data(save_data: Dictionary):
	name = save_data["name"]
	offset = save_data["offset"]
	rect_size = save_data["size"]

func get_labels() -> Array:
	var labels: Array = []
	for node in get_children():
		if node is Label: labels.append(node)
	
	return labels
