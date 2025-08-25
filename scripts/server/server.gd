@tool
extends Node

var server_info:ServerInfo = ServerInfo.new()
signal receive_server_info
func start() -> void:
	Adaptor.connected_to_server.connect(connected_to_server)
	Adaptor.message_received.connect(message_received)
	Adaptor.connect_server()
	
func connected_to_server() -> void:
	Adaptor.send(JSON.stringify(Message.GetServerInfoMessage))

func message_received(message:Variant) -> void:
	var json = JSON.new()
	var server_message = json.parse_string(message)
	var server_message_kind = Message.SERVER_MESSAGE_KIND_VALUE_MAP.find_key(server_message.kind)
	match server_message_kind:
		Message.ServerMessageKind.ServerInfo:
			server_info.from_content(server_message.content)
			receive_server_info.emit()
