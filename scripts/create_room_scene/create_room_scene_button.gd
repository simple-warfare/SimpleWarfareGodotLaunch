@tool
extends "res://components/main_button.gd"
class_name  CreateSceneButton

enum Kind{
	ChangeMap,
	Create,
	Back
}
	
@export var kind : Kind:
	set(v):
		kind = v
		if lbl:
			description = Globals.get_create_room_scene_button_description(v)
			lbl.text = description
			_update_layout()
		

func _on_ready() -> void:
	description = Globals.get_create_room_scene_button_description(kind)
	lbl.text = description
