tool
extends PanelContainer

var tree_resource: TreeRes
func set_tree_resource(tree_res: TreeRes):
	tree_resource = tree_res
	secuence_editor.characters = tree_resource.characters
	choice_editor.characters = tree_resource.characters
	condition_editor.properties = tree_resource.properties

onready var secuence_editor: PanelContainer = $SecuenceEditor
onready var choice_editor: PanelContainer = $ChoiceEditor
onready var condition_editor: PanelContainer = $ConditionEditor

func select_node(node: TreeNode):
	hide_editors()
	
	match node.get_class():
		"SecuenceNode": 
			secuence_editor.characters = tree_resource.characters
			secuence_editor.set_current_node(node)
			secuence_editor.show()
		"ChoiceNode":
			choice_editor.characters = tree_resource.characters
			choice_editor.set_current_node(node)
			choice_editor.show()
		"ConditionNode":
			condition_editor.properties = tree_resource.properties
			condition_editor.set_current_node(node)
			condition_editor.show()
	
func hide_editors():
	secuence_editor.hide()
	secuence_editor.current_node = null
	choice_editor.hide()
	choice_editor.current_node = null
	condition_editor.hide()
	condition_editor.current_node = null

func save_resource():
	if secuence_editor.current_node != null:
		secuence_editor.current_node.display_secuence()
	if choice_editor.current_node != null:
		choice_editor.current_node.display_choices()
	if condition_editor.current_node != null:
		condition_editor.current_node.display_condition()
