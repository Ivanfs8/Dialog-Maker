tool
extends TreeNode
class_name StartNode

onready var preview_container: VBoxContainer = $ScrollContainer/PreviewContainer

var start_data: Array = []

func get_class(): return "StartNode"

func _draw(): $ScrollContainer.rect_size.y = rect_size.y - 50

func get_save_data() -> Dictionary:
	var data: Dictionary = .get_save_data()
	data["start_data"] = start_data
	
	return data

func load_save_data(save_data: Dictionary):
	.load_save_data(save_data)
	if save_data.has("start_data"): start_data = save_data["start_data"]
	else: start_data = []
	
	display_data()
	
func display_data(d_name: String = ""):
	for label in preview_container.get_children():
		if label is Label: label.queue_free()
	
	for data in start_data:
		data = data as Dictionary
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
#		new_label.autowrap = true
#		new_label.max_lines_visible = 2
		
		if d_name == "":
			new_label.text = "[" + String(data["chara_id"]) + "] "
		else:
			new_label.text = "[" + d_name + "] "
		preview_container.add_child(new_label)
#		set_slot(i, false, 0, Color.white, true, 0, Color.white)
