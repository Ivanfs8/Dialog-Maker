tool
extends EditorInspectorPlugin

func can_handle(object):
	return object is TreeRes

func parse_property(object, type, path, hint, hint_text, usage):
	return !path == "characters"
