tool
extends PanelContainer

var tree_resource: TreeRes setget set_tree_resource
func set_tree_resource(tree_res: TreeRes):
	tree_resource = tree_res
	start_editor.characters = tree_resource.characters
	secuence_editor.characters = tree_resource.characters
	choice_editor.characters = tree_resource.characters
	condition_editor.properties = tree_resource.properties
	
	if tree_res.character_settings.empty():
		for i in tree_res.characters.size():
			tree_res.character_settings.append(tree_res.get_default_character_settings(i))
		print("chara_settings applied")
	on_characters_change()

onready var start_editor: PanelContainer = $StartEditor
onready var secuence_editor: PanelContainer = $SecuenceEditor
onready var choice_editor: PanelContainer = $ChoiceEditor
onready var condition_editor: PanelContainer = $ConditionEditor

func select_node(node: TreeNode):
	hide_editors()
	
	match node.get_class():
		"StartNode":
			start_editor.characters = tree_resource.characters
			start_editor.set_current_node(node)
			start_editor.show()
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
	start_editor.hide()
	start_editor.current_node = null
	secuence_editor.hide()
	secuence_editor.current_node = null
	choice_editor.hide()
	choice_editor.current_node = null
	condition_editor.hide()
	condition_editor.current_node = null

func save_resource():
	if start_editor.current_node != null:
		start_editor.current_node.display_data()
	if secuence_editor.current_node != null:
		secuence_editor.current_node.display_secuence()
	if choice_editor.current_node != null:
		choice_editor.current_node.display_choices()
	if condition_editor.current_node != null:
		condition_editor.current_node.display_condition()

func on_characters_change(_active: bool = true, _characters: Array = []):
	if tree_resource.character_settings.size() < tree_resource.characters.size():
#		var diff: int = tree_resource.characters.size() - tree_resource.character_settings.size()
		for i in tree_resource.characters.size():
			if tree_resource.character_settings.size() - 1 < i:
				tree_resource.character_settings.append(tree_resource.get_default_character_settings(i))
			elif tree_resource.character_settings[i]["file_name"] != tree_resource.characters[i].get_file_name():
				tree_resource.character_settings[i] = tree_resource.get_default_character_settings(i)
		print("chara_settings added new characters")
	elif tree_resource.character_settings.size() > tree_resource.characters.size():
		var remove_queue: PoolIntArray
		
		for i in tree_resource.character_settings.size():
			var present: bool = false
			for j in tree_resource.characters.size():
				if tree_resource.character_settings[i]["file_name"] == tree_resource.characters[j].get_file_name():
					present = true
					break
			if !present: remove_queue.append(i)
		
		for i in remove_queue:
			print("removed ", tree_resource.character_settings[i]["file_name"], " at index ", i)
			tree_resource.character_settings.remove(i)
		
		print("chara_settings removed characters")
