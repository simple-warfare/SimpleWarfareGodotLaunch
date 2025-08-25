extends Control
@export var room_menu_button_group: ButtonGroup

var menu_kind:MenuKind

func _ready() -> void:
	room_menu_button_group.pressed.connect(room_menu_button_pressed)
		
func room_menu_button_pressed(button:Button) -> void:
	match button.kind:
		RoomSceneButton.Kind.StartGame:
			Globals.next_scene("res://scenes/game.tscn")
	
	button.button_pressed = false
