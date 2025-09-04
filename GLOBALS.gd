@tool
extends Node

var SERVER_PATH = {
	Globals.OsKind.Linux:"user://simple_warfare_server",
	Globals.OsKind.Windows:"user://simple_warfare_server.exe"
}

const LOADING_SCENE = preload("res://scenes/loading.tscn")
const CRASH_SCENE = preload("res://scenes/crash.tscn")
const NOW_USE_MOD_SET_CONF = "user://assets/mod_set/now_use.conf"
const DEFALUT_MOD_SET = "user://assets/mod_set/defalut.toml"
var loading_scene = LOADING_SCENE.instantiate()
var crash_scene = CRASH_SCENE.instantiate()

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
	
func get_loading_scene_ready_signal() -> Signal:
	return loading_scene.scene_ready
	
func get_loading_change_scene_signal() -> Signal:
	return loading_scene.change_scene
	
func get_loading_tip_label() -> RichTextLabel:
	return loading_scene.tip_label

func next_scene_and_free_current(scene_path:String) -> void:
	get_tree().current_scene.queue_free()
	loading_scene.next(scene_path)
	loading_scene.scene_ready.connect(change_scene)
	add_child(loading_scene)

func next_scene(scene_path:String) -> Signal:
	loading_scene.next(scene_path)
	add_child(loading_scene)
	return loading_scene.scene_ready
	
func next_scene_and_change_when_ready(scene_path:String) -> void:
	get_tree().current_scene.queue_free()
	loading_scene.next(scene_path)
	loading_scene.scene_ready.connect(change_scene)
	add_child(loading_scene)
	
func change_scene(loading_scene):
	loading_scene.change_scene.emit()
	loading_scene.scene_ready.disconnect(change_scene)
	
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


func crash(crash_reason:String):
	get_tree().current_scene.queue_free()
	crash_scene.crash_reason.text = crash_reason
	add_child(crash_scene)
