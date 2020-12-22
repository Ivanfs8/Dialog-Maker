tool
extends PanelContainer

const ForcePreload = {
	"TreeRes": preload("res://addons/dialog_maker/scripts/tree_res.gd"),
	"TreeNode": preload("res://addons/dialog_maker/scripts/nodes/node_base.gd"),
	"StartNode": preload("res://addons/dialog_maker/scripts/nodes/start_node.gd"),
	"SecuenceNode": preload("res://addons/dialog_maker/scripts/nodes/secuence_node.gd"),
	"ChoiceNode": preload("res://addons/dialog_maker/scripts/nodes/choice_node.gd"),
	"SecuenceEditor": preload("res://addons/dialog_maker/scripts/nodes/secuence_node.gd"),
	"DialoguePanel": preload("res://addons/dialog_maker/scripts/dialogue_panel.gd"),
	"ChoiceEditor": preload("res://addons/dialog_maker/scripts/choice_editor.gd"),
	"ChoicePanel": preload("res://addons/dialog_maker/scripts/choice_panel.gd")
}

var undo_redo: UndoRedo

var tree_resource: TreeRes = null setget set_tree_resource
func set_tree_resource(tree: TreeRes):
	if tree == null:
		return
	
	tree_graph.clear_all_nodes()
	tree_resource = tree
	
	if tree.characters.empty():
		invalid_tree_resource("Please add characters to the resource")
		return
	
	tree_graph.load_resource(tree_resource)
	
	secuence_editor.characters = tree_resource.characters
	choice_editor.characters = tree_resource.characters
	$Label.hide()
	$HSplitContainer.show()

onready var tree_graph: GraphEdit = $HSplitContainer/TreeVBoxContainer/TreeGraphEdit
onready var secuence_editor = $HSplitContainer/HBoxContainer/SecuenceEditor
onready var choice_editor = $HSplitContainer/HBoxContainer/ChoiceEditor

func _ready():
	invalid_tree_resource()
	secuence_editor.hide()
	choice_editor.hide()

func invalid_tree_resource(text: String = "Please select a dialogue resource"):
	$Label.text = text
	$Label.show()
	$HSplitContainer.hide()

func save_resource():
	if tree_resource != null:
		if secuence_editor.current_node != null:
			secuence_editor.current_node.display_secuence()
		if choice_editor.current_node != null:
			choice_editor.current_node.display_choices()
		
		tree_graph.save_resource(tree_resource)
		
#		tree_resource.take_over_path(tree_resource.resource_path)
		
		var err := ResourceSaver.save(tree_resource.resource_path, tree_resource)
		print(err)

func _on_TreeGraphEdit_node_selected(node: TreeNode):
	secuence_editor.hide()
	secuence_editor.current_node = null
	choice_editor.hide()
	choice_editor.current_node = null
	
	match node.get_class():
		"SecuenceNode": 
			secuence_editor.characters = tree_resource.characters
			secuence_editor.set_current_node(node)
			secuence_editor.show()
		"ChoiceNode":
			choice_editor.characters = tree_resource.characters
			choice_editor.set_current_node(node)
			choice_editor.show()
