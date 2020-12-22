tool
extends TreeNode
class_name ChoiceNode

func get_class(): return "ChoiceNode"

var question: TreeRes.Dialogue = TreeRes.Dialogue.new()
var choices: Array = []

func get_save_data() -> Dictionary:
	var data: Dictionary = .get_save_data()
	data["question"] = question
	data["choices"] = choices
	
	return data

func load_save_data(save_data: Dictionary):
	.load_save_data(save_data)
	question = save_data["question"]
	choices = save_data["choices"]
	
	display_choices()

func display_choices(only_question: bool = false):
	$Question.text = "[" + String(question.character_id) + "] " + question.text
	if only_question: return
	
	var labels: Array = get_labels()
	labels.remove(0)
	for label in labels:
		label.queue_free()
	
	var i: int = 1
	for choice in choices:
		choice = choice as TreeRes.Choice
#		print("[" + String(dialog.character_id) + "] " + dialog.text)
		
		var new_label = Label.new()
		new_label.text = choice.text
		add_child(new_label)
		set_slot(i, false, 0, Color.white, true, 0, Color.white)
		
		i+=1
