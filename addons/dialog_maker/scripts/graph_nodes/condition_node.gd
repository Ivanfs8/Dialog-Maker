tool
extends DgTreeNode
class_name ConditionNode

func get_class() -> String: return "ConditionNode"

class SaveDataConditions extends DgTreeNode.SaveData:
	var conditions: Array

var conditions: Array #name, type, comparator, value

func get_save_data() -> SaveDataConditions:
	var data: SaveDataConditions
	data.load_save_data(.get_save_data())
	data.conditions = conditions
	
	return data
	
func load_save_data(save_data: SaveDataConditions):
	.load_save_data(save_data.get_as_save_data())
	conditions = save_data.conditions
	
	display_condition()

func display_condition():
	if conditions.empty(): return
	var s: String
	for con in conditions:
		con = con as DialogMaker.Condition
		s += str("if: ", con.prop_name, " ", 
		get_comparator_display(con.comp), " ", con.value, "\n")
	$PreviewLabel.text = s

static func get_comparator_display(comparator: int) -> String:
	match comparator:
		DialogMaker.COMP.EQUAL: return "=="
		DialogMaker.COMP.NOT: return "!="
		DialogMaker.COMP.LESS: return "<"
		DialogMaker.COMP.MORE: return ">"
		DialogMaker.COMP.LESS_OR_EQUAL: return "<="
		DialogMaker.COMP.MORE_OR_EQUAL: return ">="
	
	return ""
