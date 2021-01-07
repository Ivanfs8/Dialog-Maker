tool
extends PanelContainer
class_name ConditionPanel

signal condition_edited

var index: int

var properties: Dictionary

onready var prop_option: OptionButton = $HBoxContainer/PropertyOptionButton
onready var comp_option: OptionButton = $HBoxContainer/ComparatorOptionButton
onready var value_edit: LineEdit = $HBoxContainer/ValueLineEdit
onready var delete_button: Button = $HBoxContainer/DeleteButton

func _exit_tree():
	if Engine.editor_hint: return
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])
	
	for sig in get_signal_connection_list("condition_edited"):
		disconnect(sig["signal"], sig["target"], sig["method"])

func load_condition(props: Dictionary, cond: Dictionary) -> void:
	properties = props
	
	prop_option.clear()
	for prop in properties:
		prop_option.add_item(prop)
	
	var id: int = 0
	for ind in properties.size():
		#print(str("prop_ind: ", ind))
		if prop_option.get_item_text(ind) == cond["name"]:
			id = ind
			break
	
	prop_option.select(id)
	
	comp_option.select(cond["comparator"])
	
	value_edit.text = cond["value"]

#name, type, comparator, value
func get_condition() -> Dictionary:
	var cond: Dictionary = {
		"name": prop_option.get_item_text(prop_option.selected), 
		"type": properties[prop_option.get_item_text(prop_option.selected)],
		"comparator": comp_option.selected,
		"value": value_edit.text
	}
	
	return cond

func on_edit(_option_id: int = -1):
	emit_signal("condition_edited")

func on_change_properties(active: bool, _properties: Dictionary):
	var select: int = prop_option.selected
	
	prop_option.clear()
	for prop in _properties:
		prop_option.add_item(prop)
	
	if active:
		prop_option.select(select)
	else:
		prop_option.select( int(clamp(select, 0, prop_option.get_item_count() - 1 )) )
