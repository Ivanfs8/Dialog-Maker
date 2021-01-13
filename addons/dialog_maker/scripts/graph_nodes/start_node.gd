tool
extends DgTreeNode
class_name StartNode

func get_class(): return "StartNode"

class SaveDataStart extends DgTreeNode.SaveData:
	var start_data: Array

onready var preview_container: VBoxContainer = $ScrollContainer/PreviewContainer

var start_data: Array = []

func _draw(): $ScrollContainer.rect_size.y = rect_size.y - 50

func get_save_data() -> SaveDataStart:
	var data: SaveDataStart
	data.load_save_data(.get_save_data())
	data.start_data = start_data
	
	return data

func load_save_data(save_data: SaveDataStart):
	.load_save_data(save_data.get_as_save_data())
	start_data = save_data.start_data
	
	display_data()
	
func display_data(d_name: String = ""):
	for label in preview_container.get_children():
		if label is Label: label.queue_free()
	
	for data in start_data:
		data = data as DialogMaker.StartData
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
#		new_label.autowrap = true
#		new_label.max_lines_visible = 2
		
		if d_name == "":
			new_label.text = "[" + String(data.chara_id) + "] "
		else:
			new_label.text = "[" + d_name + "] "
		preview_container.add_child(new_label)
#		set_slot(i, false, 0, Color.white, true, 0, Color.white)
