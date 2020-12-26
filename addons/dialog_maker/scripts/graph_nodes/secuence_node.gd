tool
extends TreeNode
class_name SecuenceNode

var secuence: Array = []

func get_class(): return "SecuenceNode"

func get_save_data() -> Dictionary:
	var data: Dictionary = .get_save_data()
	data["secuence"] = secuence
	
	return data
	
func load_save_data(save_data: Dictionary):
	.load_save_data(save_data)
	secuence = save_data["secuence"]
	
	display_secuence()

func display_secuence():
	for label in get_labels():
		label.queue_free()
	
	for dialog in secuence:
		dialog = dialog as Dictionary
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
		new_label.autowrap = true
		new_label.max_lines_visible = 2
		
		new_label.text = "[" + String(dialog["chara_id"]) + "] " + dialog["text"]
		add_child(new_label)
#		set_slot(i, false, 0, Color.white, true, 0, Color.white)


