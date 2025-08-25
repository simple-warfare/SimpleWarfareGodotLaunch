@tool
extends Node
enum ClientMessageKind{
	StartServer,
	StartLobby,
	GetServerInfo
}
enum ServerMessageKind{
	ServerInfo
}
var SERVER_MESSAGE_KIND_VALUE_MAP = {
	ServerMessageKind.ServerInfo:"ServerInfo",
}

var CLIENT_MESSAGE_KIND_VALUE_MAP = {
	ClientMessageKind.StartServer:"StartServer",
	ClientMessageKind.StartLobby:"StartLobby",
	ClientMessageKind.GetServerInfo:"GetServerInfo",
}

var GetServerInfoMessage = {
	kind = CLIENT_MESSAGE_KIND_VALUE_MAP.get(ClientMessageKind.GetServerInfo)
}

var StartServerMessage = {
	kind = CLIENT_MESSAGE_KIND_VALUE_MAP.get(ClientMessageKind.StartServer)
}
