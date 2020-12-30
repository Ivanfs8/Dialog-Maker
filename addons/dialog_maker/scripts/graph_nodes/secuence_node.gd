tool
extends TreeNode
class_name SecuenceNode

onready var preview_container: VBoxContainer = $ScrollContainer/PreviewContainer

var secuence: Array = []

func get_class(): return "SecuenceNode"

func _draw():
	$ScrollContainer.rect_size.y = rect_size.y - 50

func get_save_data() -> Dictionary:
	var data: Dictionary = .get_save_data()
	data["secuence"] = secuence
	
	return data
	
func load_save_data(save_data: Dictionary):
	.load_save_data(save_data)
	secuence = save_data["secuence"]
	
	display_secuence()

func display_secuence():
	for label in preview_container.get_children():
		if label is Label: label.queue_free()
	
	for dialog in secuence:
		dialog = dialog as Dictionary
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
#		new_label.autowrap = true
#		new_label.max_lines_visible = 2
		
		new_label.text = "[" + String(dialog["chara_id"]) + "] " + dialog["text"]
		preview_container.add_child(new_label)
#		set_slot(i, false, 0, Color.white, true, 0, Color.white)


