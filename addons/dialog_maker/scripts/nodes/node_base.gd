tool
extends GraphNode
class_name TreeNode

class Dialogue:
	var character_id: int = 0
	var text: String = ""

class Choice:
	var text: String = ""

func get_class(): return "TreeNode"

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
