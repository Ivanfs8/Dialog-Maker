tool
extends CheckBox

var parent_ref: Control

func _exit_tree():
	if Engine.editor_hint: return
	for sig in get_signal_connection_list("toggled"):
		disconnect(sig["signal"], sig["target"], sig["method"])
	
#	if is_connected("toggled", parent_ref, "_on_chara_button_toggled"):
#		disconnect("toggled", parent_ref, "_on_chara_button_toggled")
