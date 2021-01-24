tool
extends EditorPlugin

const MainPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/TreeEditor.tscn")
const MainPanel: Script = preload("res://addons/dialog_maker/scripts/main_panel.gd")
#const InspectorPlugin: Script = preload("res://addons/dialog_maker/inspector_plugin.gd")

var main_panel_instance: MainPanel

const EditorDockScene: PackedScene = preload("res://addons/dialog_maker/scenes/EditorDock.tscn")

var editor_dock_instance: Control

func _enter_tree():
	main_panel_instance = MainPanelScene.instance()
	main_panel_instance.undo_redo = get_undo_redo()
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	
	editor_dock_instance = EditorDockScene.instance()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, editor_dock_instance)
	
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

func _ready():
	#	get_node("HSplitContainer/TreeVBoxContainer/TreeGraphEdit")
	main_panel_instance.tree_graph.connect("node_selected", editor_dock_instance, "select_node")
	main_panel_instance.character_tab.connect("character_changed", editor_dock_instance, "on_characters_change")
	main_panel_instance.character_tab.connect("character_changed", editor_dock_instance.start_editor, "on_characters_change")
	main_panel_instance.character_tab.connect("character_changed", editor_dock_instance.secuence_editor, "on_characters_change")
	main_panel_instance.character_tab.connect("character_changed", editor_dock_instance.choice_editor, "on_characters_change")
	main_panel_instance.properties_tab.connect("property_changed", editor_dock_instance.condition_editor, "on_properties_change")

func _exit_tree():
	if main_panel_instance:
#		remove_control_from_bottom_panel(main_panel_instance)
		main_panel_instance.queue_free()
	if editor_dock_instance:
		remove_control_from_docks(editor_dock_instance)
		editor_dock_instance.queue_free()
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
		editor_dock_instance.hide_editors()
		#main_panel_instance.set_tree_resource(null)
		
		return false

func edit(object):
	object = object as TreeRes
	OS.low_processor_usage_mode = true
	editor_dock_instance.set_tree_resource(object)
	main_panel_instance.set_tree_resource(object)
	
func save_external_data():
	if main_panel_instance && main_panel_instance.tree_resource != null:
		editor_dock_instance.save_resource()
		main_panel_instance.save_resource()
