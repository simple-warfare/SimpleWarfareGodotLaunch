@tool
extends Node

var MAIN_MENU_BUTTON_MAP = {
	MainMenuButton.Kind.Singleplayer:"Singleplayer",
	MainMenuButton.Kind.Multiplayer:"Multiplayer",
	MainMenuButton.Kind.Mods:"Mods",
	MainMenuButton.Kind.Settings:"Settings",
	MainMenuButton.Kind.Community:"Community",
	MainMenuButton.Kind.News:"News",
	MainMenuButton.Kind.Quit:"Quit"
}
var MOD_SCENE_BUTTON_MAP = {
	ModSceneButton.Kind.SaveAndUse:"SaveAndUse",
	ModSceneButton.Kind.ModAssetLib:"ModAssetLib",
	ModSceneButton.Kind.EnableMod:"EnableMod",
	ModSceneButton.Kind.DisableMod:"DisableMod",
	ModSceneButton.Kind.SaveModSet:"SaveModSet",
	ModSceneButton.Kind.ChangeModSet:"ChangeModSet",
}
var MULTIPLAYER_SCENE_BUTTON_MAP = {
	MultiplayerSceneButton.Kind.FilterGames:"Filter Games",
	MultiplayerSceneButton.Kind.DirectIp:"Direct IP",
	MultiplayerSceneButton.Kind.Create:"Create",
	MultiplayerSceneButton.Kind.LeaveChat:"Leave Chat",
	MultiplayerSceneButton.Kind.Back:"Back",
}

var CREATE_ROOM_SCENE_BUTTON_MAP = {
	CreateSceneButton.Kind.ChangeMap:"Change Map",
	CreateSceneButton.Kind.Create:"Create",
	CreateSceneButton.Kind.Back:"Back",
}

var SINGLEPLAYER_MENU_BUTTON_MAP = {
	SingleplayerMenuButton.Kind.Skirmish:"Skirmish",
	SingleplayerMenuButton.Kind.Missions:"Missions",
	SingleplayerMenuButton.Kind.SandBox:"SandBox",
	SingleplayerMenuButton.Kind.Back:"Back",
}

var ROOM_MENU_BUTTON_MAP = {
	RoomSceneButton.Kind.SlotAdmin:"Slot Admin",
	RoomSceneButton.Kind.Players:"Players",
	RoomSceneButton.Kind.Options:"Options",
	RoomSceneButton.Kind.Music:"Music",
	RoomSceneButton.Kind.ChangeMap:"Change Map",
	RoomSceneButton.Kind.Game:"Game",
	RoomSceneButton.Kind.Global:"Global",
	RoomSceneButton.Kind.StartGame:"Start Game",
	RoomSceneButton.Kind.All:"All",
	RoomSceneButton.Kind.Status:"Status",
	RoomSceneButton.Kind.Back:"Back",
}

var SERVER_PATH = {
	Globals.OsKind.Linux:"user://server/simple_warfare_server",
	Globals.OsKind.Windows:"user://server/simple_warfare_server.exe"
}

const LOADING_SCENE = preload("res://scenes/loading.tscn")
const NOW_USE_MOD_SET_CONF = "user://assets/mod_set/now_use.conf"
const DEFALUT_MOD_SET = "user://assets/mod_set/defalut.toml"
var loading_scene = LOADING_SCENE.instantiate()

const MOD_SET_DIR = "user://assets/mod_set/"
const MODS_DIR = "user://assets/mods/"
const CUSTOM_MODS_DIR = "user://assets/mods/custom/"
var all_mod_sets = Dictionary()
var all_mod_infos = Dictionary()
var all_enable_mod_to_mod_infos = Dictionary()

var mod_set:ModSet

var server_config:ServerConfig

enum OsKind{
	Windows,
	MacOS,
	Linux,
	Android,
	IOS,
	Web,
	Unknown
}
func _ready() -> void:
	loading_scene.scene_changed.connect(scene_changed)	
	load_mod_infos()
	load_mod_set()
	server_config = ServerConfig.new()
	server_config.load("res://configs/server.cfg")
	
func get_main_menu_button_description(button_kind:MainMenuButton.Kind) -> String:
	return MAIN_MENU_BUTTON_MAP.get(button_kind,"UNKNOWN")
	
func get_mod_scene_button_description(button_kind:ModSceneButton.Kind) -> String:
	return MOD_SCENE_BUTTON_MAP.get(button_kind,"UNKNOWN")

func get_multiplayer_scene_button_description(button_kind:MultiplayerSceneButton.Kind) -> String:
	return MULTIPLAYER_SCENE_BUTTON_MAP.get(button_kind,"UNKNOWN")

func get_create_room_scene_button_description(button_kind:CreateSceneButton.Kind) -> String:
	return CREATE_ROOM_SCENE_BUTTON_MAP.get(button_kind,"UNKNOWN")
	
func get_singleplayer_menu_button_description(button_kind:SingleplayerMenuButton.Kind) -> String:
	return SINGLEPLAYER_MENU_BUTTON_MAP.get(button_kind,"UNKNOWN")

func get_room_scene_button_description(button_kind:RoomSceneButton.Kind) -> String:
	return ROOM_MENU_BUTTON_MAP.get(button_kind,"UNKNOWN")
	
func next_scene(scene_path:String):
	get_tree().current_scene.queue_free()
	loading_scene.next(scene_path)
	add_child(loading_scene)

func scene_changed():
	remove_child(loading_scene)
	
func load_mod_set():
	var mod_set_dir = DirAccess.open(MOD_SET_DIR)
	var files = mod_set_dir.get_files()
	for file in files:
		if file.ends_with(".json"):
			all_mod_sets.set(file, ModSet.new(all_mod_infos,MOD_SET_DIR + file))
		
	if FileAccess.file_exists(NOW_USE_MOD_SET_CONF):
		var now_use_mod_set = FileAccess.open(NOW_USE_MOD_SET_CONF,FileAccess.READ)
		if now_use_mod_set:
			var mod_set_name = now_use_mod_set.get_line()
			mod_set = all_mod_sets.get(mod_set_name)
		else:
			print("now use mod_set not found")



func load_mod_infos():
	var mod_info_folders = PackedStringArray()
	get_mod_info_path(CUSTOM_MODS_DIR,mod_info_folders)
	for mod_info_folder in mod_info_folders:
		var dir_access = DirAccess.open(CUSTOM_MODS_DIR)
		var mod_info_file = FileAccess.open(mod_info_folder,FileAccess.READ)
		all_mod_infos.set(mod_info_folder,ModInfo.new(dir_access.get_current_dir() + mod_info_folder + "/mod_info.json"))


func get_mod_info_path(path:String,mod_info_folders:PackedStringArray) -> void:
	var dir_access = DirAccess.open(path)
	if dir_access:
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		while file_name != "":
			if dir_access.current_is_dir():
				var mod_info_path = dir_access.get_current_dir() + file_name + "/mod_info.json"
				if FileAccess.file_exists(mod_info_path):
					mod_info_folders.append(file_name)
					
			file_name = dir_access.get_next()


func get_os_type() -> OsKind:
	var kind = OsKind.Unknown
	match OS.get_name():
		"Windows":
			kind = OsKind.Windows
		"macOS":
			kind = OsKind.MacOS
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			kind = OsKind.Linux
		"Android":
			kind = OsKind.Android
		"iOS":
			kind = OsKind.IOS
		"Web":
			kind = OsKind.Web
	return kind
