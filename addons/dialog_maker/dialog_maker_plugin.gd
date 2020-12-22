tool
extends EditorPlugin

const MainPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/TreeEditor.tscn")
const MainPanel: Script = preload("res://addons/dialog_maker/scripts/main_panel.gd")

var main_panel_instance: MainPanel

func _enter_tree():
	main_panel_instance = MainPanelScene.instance()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	make_visible(false)

func _exit_tree():
	if main_panel_instance:	main_panel_instance.queue_free()
	OS.low_processor_usage_mode = false

func has_main_screen():
	return true

func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible
	if !visible:
#		main_panel_instance.set_tree_resource(null)
		OS.low_processor_usage_mode = false

func get_plugin_name():
	return "Dialog Maker"

func get_plugin_icon():
	return preload("res://addons/dialog_maker/icons/GuiEllipsis.svg")
	#get_editor_interface().get_base_control().get_icon("Tree", "EditorIcons")

func handles(object):
	if object is TreeRes:
		return true
	else:
		main_panel_instance.invalid_tree_resource()
		#main_panel_instance.set_tree_resource(null)
		return false

func edit(object):
	OS.low_processor_usage_mode = true
	main_panel_instance.set_tree_resource(object)

func save_external_data():
	main_panel_instance.call_deferred("save_resource")
