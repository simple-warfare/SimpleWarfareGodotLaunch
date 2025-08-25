class_name ServerConfig

var url:String = "ws://127.0.0.1:25570"
var server_path:String

func save(path:String) -> void:
	var config = ConfigFile.new()
	
	config.set_value("server","url",url)
	config.save(path)
	
func load(path:String) -> void:
	var config = ConfigFile.new()
	var server_config = ServerConfig.new()
	var err = config.load(path)
	if err != OK:
		return
	self.server_path = Globals.SERVER_PATH.get(Globals.get_os_type(),"Unkown")
	if server_path == "Unkown":
		return
	var section = config.get_sections()[0]
	self.url = config.get_value(section, "url")
	
