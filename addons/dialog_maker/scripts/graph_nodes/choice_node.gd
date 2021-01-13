tool
extends DgTreeNode
class_name ChoiceNode

func get_class(): return "ChoiceNode"

class SaveDataChoices extends DgTreeNode.SaveData:
	var question: DialogMaker.Dialogue
	var choices: PoolStringArray
	var conditions: Array

var question: DialogMaker.Dialogue
var choices: PoolStringArray = []

func get_save_data() -> SaveDataChoices:
	var data: SaveDataChoices
	data.load_save_data(.get_save_data())
	data.question = question
	data.choices = choices
	
	return data

func load_save_data(save_data: SaveDataChoices):
	.load_save_data(save_data.get_as_save_data())
	question = save_data.question
	choices = save_data.choices
	
	display_choices()

func display_choices(only_question: bool = false):
	$Question.text = "[" + String(question.chara_id) + "] " + question.text
	if only_question: return
	
	var labels: Array = get_labels()
	labels.remove(0)
	for label in labels:
		label.queue_free()
	
	var i: int = 1
	for choice in choices:
		choice = choice as String
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label: Label = Label.new()
		new_label.autowrap = true
		new_label.max_lines_visible = 2
		
		new_label.text = choice
		add_child(new_label)
		set_slot(i, true, 1, Color(1, 0.392157, 0.392157), true, 0, Color.white)
		
		i+=1
