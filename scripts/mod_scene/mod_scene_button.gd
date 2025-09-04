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
			description = Kind.keys()[v]
			lbl.text = description
			_update_layout()
		

func _on_ready() -> void:
	description = Kind.keys()[kind]
	lbl.text = description
