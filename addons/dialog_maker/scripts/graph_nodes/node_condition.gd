tool
extends TreeNode
class_name ConditionNode

func get_class() -> String: return "ConditionNode"

var conditions: Array #name, type, comparator, value

func get_save_data() -> Dictionary:
	var data: Dictionary = .get_save_data()
	data["conditions"] = conditions
	
	return data
	
func load_save_data(save_data: Dictionary):
	.load_save_data(save_data)
	conditions = save_data["conditions"]
	
	display_condition()

func display_condition():
	if conditions.empty(): return
	var s: String
	for con in conditions:
		s += str("if: ", con["name"], " ", 
		get_condition_display(con["comparator"]), " ", con["value"], "/n")
	$PreviewLabel.text = s

func get_condition_display(comparator: int) -> String:
	match comparator:
		TreeRes.COMP.EQUAL: return "=="
		TreeRes.COMP.NOT: return "!="
		TreeRes.COMP.LESS: return "<"
		TreeRes.COMP.MORE: return ">"
		TreeRes.COMP.LESS_OR_EQUAL: return "<="
		TreeRes.COMP.MORE_OR_EQUAL: return ">="
	
	return ""
