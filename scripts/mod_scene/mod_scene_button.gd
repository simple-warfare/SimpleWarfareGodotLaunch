@tool
extends "res://components/main_button.gd"
class_name  ModSceneButton

enum Kind{
	SaveAndUse,
	ModAssetLib,
	DisableMod,
	EnableMod,
	SaveModSet,
	ChangeModSet,
}
	
@export var kind : Kind:
	set(v):
		kind = v
		if lbl:
			description = Globals.get_mod_scene_button_description(v)
			lbl.text = description
			_update_layout()
		

func _on_ready() -> void:
	description = Globals.get_mod_scene_button_description(kind)
	lbl.text = description
