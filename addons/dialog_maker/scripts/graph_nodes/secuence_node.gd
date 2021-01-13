tool
extends DgTreeNode
class_name SecuenceNode

onready var preview_container: VBoxContainer = $ScrollContainer/PreviewContainer

var secuence: Array = []

func get_class(): return "SecuenceNode"

class SaveDataSecuence extends DgTreeNode.SaveData:
	var secuence: Array
	var condition: DialogMaker.Condition

func _draw():
	$ScrollContainer.rect_size.y = rect_size.y - 50

func get_save_data() -> SaveDataSecuence:
	var data: SaveDataSecuence
	data.load_save_data(.get_save_data())
	data.secuence = secuence
	
	return data
	
func load_save_data(save_data: SaveDataSecuence):
	.load_save_data(save_data.get_as_save_data())
	secuence = save_data.secuence
	
	display_secuence()

func display_secuence(d_name: String = ""):
	for label in preview_container.get_children():
		if label is Label: label.queue_free()
	
	for dialog in secuence:
		dialog = dialog as DialogMaker.Dialogue
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
#		new_label.autowrap = true
#		new_label.max_lines_visible = 2
		
		if d_name == "":
			new_label.text = "[" + String(dialog.chara_id) + "] " + dialog.text
		else:
			new_label.text = "[" + d_name + "] " + dialog.text
		preview_container.add_child(new_label)
#		set_slot(i, false, 0, Color.white, true, 0, Color.white)


