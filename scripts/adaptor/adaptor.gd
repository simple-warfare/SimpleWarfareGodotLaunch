@tool
extends Node
var server_backend:Dictionary
var client = WebSocketPeer.new()

var last_state = WebSocketPeer.STATE_CLOSED
var tls_options: TLSOptions = null
	
signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

func _ready() -> void:
	set_process(false)

func connect_server() -> int:
	#server_backend = OS.execute_with_pipe(FileAccess.open(Globals.server_config.server_path,FileAccess.READ).get_path_absolute(), [])
	set_process(true)
	print(Globals.server_config.url)
	return connect_to_url(Globals.server_config.url)

func connect_to_url(url) -> int:
	var err = client.connect_to_url(url, tls_options)
	if err != OK:
		return err
	last_state = client.get_ready_state()
	return OK


func send(message) -> int:
	if typeof(message) == TYPE_STRING:
		return client.send_text(message)
	return client.send(var_to_bytes(message))


func get_message() -> Variant:
	if client.get_available_packet_count() < 1:
		return null
	var pkt = client.get_packet()
	return pkt.get_string_from_utf8()


func close(code := 1000, reason := "") -> void:
	client.close(code, reason)
	last_state = client.get_ready_state()


func clear() -> void:
	client = WebSocketPeer.new()
	last_state = client.get_ready_state()


func get_socket() -> WebSocketPeer:
	return client


func poll() -> void:
	if client.get_ready_state() != client.STATE_CLOSED:
		client.poll()
	var state = client.get_ready_state()
	if last_state != state:
		last_state = state
		if state == client.STATE_OPEN:
			connected_to_server.emit()
		elif state == client.STATE_CLOSED:
			connection_closed.emit()
	while client.get_ready_state() == client.STATE_OPEN and client.get_available_packet_count():
		message_received.emit(get_message())


func _process(delta):
	poll()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		OS.kill(server_backend.pid)
		get_tree().quit() # default behavior
