tool
extends Control

const PropertyPanelScene: PackedScene = preload("res://addons/dialog_maker/scenes/PropertyPanel.tscn")

onready var properties_cont: VBoxContainer = $PropertiesContainer

var tree_res: TreeRes

func set_tree_resource(tree: TreeRes):
	tree_res = tree
	for panel in properties_cont.get_children():
		panel.queue_free()
	for prop in tree_res.properties:
		add_property(prop, tree_res.properties[prop])

func add_property(_name: String = "", type: int = TYPE_BOOL):
	var property_panel = PropertyPanelScene.instance()
	properties_cont.add_child(property_panel)
	property_panel.load_property(_name, type)
	
	property_panel.delete_button.connect("pressed", self, "delete_property", [property_panel])
	property_panel.connect("edited_property", self, "on_edit_property")

func delete_property(panel: Control):
	if !tree_res: return
	var key: String = panel.name_edit.text
	tree_res.properties.erase(key)
	panel.queue_free()

func on_edit_property(_name: String, type: int):
	if _name == "" || _name == null: return
	if tree_res:
		tree_res.properties.clear()
		for panel in properties_cont.get_children():
			var prop: Dictionary = panel.get_property()
			tree_res.properties[prop["name"]] = prop["type"]
