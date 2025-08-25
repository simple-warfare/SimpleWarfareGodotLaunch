class_name ModInfo
extends Resource

var mod_name:String
var version:String
var game_version:String
var description:String
var author:PackedStringArray
var uuid:String

func _init(real_path:String) -> void:
	var json = JSON.new()
	var error = json.parse(FileAccess.open(real_path,FileAccess.READ).get_as_text())
	if error == OK:
		var data_received = json.data
		self.mod_name = data_received.get("name","UnkownModName")
		self.version = data_received.get("version","UnkownModVersion")
		self.game_version = data_received.get("game_version","UnkownModGameVersion")
		self.description = data_received.get("description","UnkownModDescription")
		self.author = data_received.get("author","UnkownModAuthor")
		self.uuid = data_received.get("uuid","UnkownModUuid")
	
