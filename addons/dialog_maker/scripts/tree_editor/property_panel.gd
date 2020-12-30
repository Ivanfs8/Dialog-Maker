tool
extends PanelContainer

signal edited_property(_name, type)

onready var name_edit: LineEdit = $HBoxContainer/PropertyName
onready var type_option: OptionButton = $HBoxContainer/PropertyType
onready var delete_button: Button = $HBoxContainer/DeleteButton

func _exit_tree():
	for sig in get_signal_connection_list("edited_property"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	for sig in delete_button.get_signal_connection_list("pressed"):
		delete_button.disconnect(sig["signal"], sig["target"], sig["method"])

func load_property(_name: String, type: int):
	name_edit.text = _name
	var sel: int
	match type:
		TYPE_BOOL: sel = 0
		TYPE_INT: sel = 1 
		TYPE_REAL: sel = 2 
		TYPE_STRING: sel = 3
		_: sel = 0
	type_option.select(sel)

func get_property() -> Dictionary:
	return {
		"name": name_edit.text,
		"type": get_type_by_index(type_option.selected)
	}

func get_type_by_index(index: int) -> int:
	match index:
		0: return TYPE_BOOL
		1: return TYPE_INT
		2: return TYPE_REAL
		3: return TYPE_STRING
	
	return TYPE_NIL

func _on_PropertyName_text_changed(new_text: String):
	emit_signal("edited_property", new_text, get_type_by_index(type_option.selected))

func _on_PropertyType_item_selected(index: int):
	emit_signal("edited_property", name_edit.text, get_type_by_index(index))
