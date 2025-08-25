class_name ModSet
extends Resource

var enable_mods:PackedStringArray = PackedStringArray()

func _init(all_mod_infos:Dictionary,real_path:String) -> void:
	var json = JSON.new()
	var error = json.parse(FileAccess.open(real_path,FileAccess.READ).get_as_text())
	if error == OK:
		var data_received = json.data
		self.enable_mods = data_received.get("enable_mods",PackedStringArray())
		for mod_name in enable_mods:
			var mod_info = all_mod_infos.get("user://assets/mods/custom/"+mod_name+"/mod_info.toml")
			if mod_info:
				self.enable_mod_infos.append(mod_info)

func save() -> void:
	pass

func add_mod(mod_info:ModInfo) -> void:
	enable_mods.append(Globals.all_mod_infos.find_key(mod_info))

func remove_mod(mod_info:ModInfo) -> void:
	enable_mods.remove_at(enable_mods.find(Globals.all_mod_infos.find_key(mod_info)))

func refresh() -> void:
	replace_by(Globals.parse_mod_set(Globals.MOD_SET_DIR + Globals.all_mod_sets.find_key(self)))

func replace_by(other:ModSet) -> void:
	self.mod_set_name = other.mod_set_name
	self.enable_mod_infos = other.enable_mod_infos
	self.enable_mods = other.enable_mods
