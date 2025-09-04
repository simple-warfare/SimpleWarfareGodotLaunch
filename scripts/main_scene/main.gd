extends Control
@export var main_menu_button_group: ButtonGroup
@export var singleplayer_menu_button_group: ButtonGroup
@export var main_menu:Node
@export var singleplayer_menu:Node
@export var all_menus:Dictionary
@export var server_backend_version:Label

var menu_kind:MenuKind

func _ready() -> void:
	main_menu_button_group.pressed.connect(main_menu_button_pressed)
	singleplayer_menu_button_group.pressed.connect(singleplayer_menu_button_pressed)
	Backend.receive_server_info.connect(show_server_info)
	change_menu(MenuKind.Kind.Main)
	update_menu_show()
		
func main_menu_button_pressed(button:Button) -> void:
	match button.kind:
		MainMenuButton.Kind.Singleplayer:
			change_menu(MenuKind.Kind.Singleplayer)
		MainMenuButton.Kind.Multiplayer:
			Globals.next_scene_and_change_when_ready("res://scenes/multiplayer_lobby.tscn")
		MainMenuButton.Kind.Mods:
			Globals.next_scene_and_change_when_ready("res://scenes/mods.tscn")
		MainMenuButton.Kind.Settings:
			Globals.next_scene_and_change_when_ready("res://scenes/settings.tscn")
		MainMenuButton.Kind.Community:
			pass
		MainMenuButton.Kind.News:
			pass
		MainMenuButton.Kind.Quit:
			get_tree().quit()
	
	button.button_pressed = false
func singleplayer_menu_button_pressed(button:Button) -> void:
	match button.kind:
		SingleplayerMenuButton.Kind.Missions:
			pass
		SingleplayerMenuButton.Kind.Skirmish:
			pass
		SingleplayerMenuButton.Kind.SandBox:
			Globals.next_scene_and_change_when_ready("res://scenes/room.tscn")
		SingleplayerMenuButton.Kind.Back:
			change_menu(MenuKind.Kind.Main)
	button.button_pressed = false

func change_menu(kind:MenuKind.Kind) -> void:
	match kind:
		MenuKind.Kind.Main:
			menu_kind = all_menus.keys().get(0)
		MenuKind.Kind.Singleplayer:
			menu_kind = all_menus.keys().get(1)
	update_menu_show()
	
func update_menu_show():
	for menu_node_path in all_menus.values():
		get_node(menu_node_path).visible = false
	get_node(all_menus.get(menu_kind)).visible = true
	
func show_server_info():
	server_backend_version.text = "Server Backend Version:  " + Backend.server_info.game_version
