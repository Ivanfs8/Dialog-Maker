tool
extends EditorPlugin

const MainPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/TreeEditor.tscn")
const MainPanel: Script = preload("res://addons/dialog_maker/scripts/main_panel.gd")
#const InspectorPlugin: Script = preload("res://addons/dialog_maker/inspector_plugin.gd")

var main_panel_instance: MainPanel

func _enter_tree():
	main_panel_instance = MainPanelScene.instance()
	main_panel_instance.undo_redo = get_undo_redo()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
#	dock_button = add_control_to_bottom_panel(main_panel_instance, "Dialog Maker")
	make_visible(false)
	
	var directory: Directory = Directory.new()
	if !directory.dir_exists("res://dialog_maker_resources/"):
		var err := directory.make_dir("res://dialog_maker_resources/")
		print(err)
	if !directory.dir_exists("res://dialog_maker_resources/characters"):
		var err = directory.make_dir("res://dialog_maker_resources/characters")
		print(err)
	if !directory.dir_exists("res://dialog_maker_resources/dialogues"):
		var err = directory.make_dir("res://dialog_maker_resources/dialogues")
		print(err)

func _exit_tree():
	if main_panel_instance:
#		remove_control_from_bottom_panel(main_panel_instance)
		main_panel_instance.queue_free()
	OS.low_processor_usage_mode = false

func has_main_screen():
	return true

func make_visible(visible):
#	dock_button.visible = visible
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
	object = object as TreeRes
	OS.low_processor_usage_mode = true
	main_panel_instance.set_tree_resource(object)
	
func save_external_data():
	if main_panel_instance:
		main_panel_instance.save_resource()
