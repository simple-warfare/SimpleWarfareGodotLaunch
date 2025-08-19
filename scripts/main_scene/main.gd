extends Control
@export var main_menu_button_group: ButtonGroup

func _ready() -> void:
	main_menu_button_group.pressed.connect(button_pressed)
	
func button_pressed(button:Button) -> void:
	
	print("s")
