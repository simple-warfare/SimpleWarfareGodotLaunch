@tool
extends "res://components/main_button.gd"
class_name  RoomSceneButton

enum Kind{
	SlotAdmin,
	Players,
	Options,
	Music,
	ChangeMap,
	Game,
	Global,
	StartGame,
	Back,
	All,
	Status
}
	
@export var kind : Kind:
	set(v):
		kind = v
		if lbl:
			description = Globals.get_room_scene_button_description(v)
			lbl.text = description
			_update_layout()
		

func _on_ready() -> void:
	description = Globals.get_room_scene_button_description(kind)
	lbl.text = description
