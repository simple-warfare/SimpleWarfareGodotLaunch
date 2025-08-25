extends Button
var mod_info:ModInfo

func new(mod_info:ModInfo) -> void:
	self.mod_info = mod_info

func _ready() -> void:
	self.text = mod_info.mod_name
