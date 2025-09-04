extends Control
var loading_scene_ready_signal:Signal
var loading_scene_tip_label:RichTextLabel
var loading_scene_ready:bool
var change_scene:Signal

func _ready() -> void:
	loading_scene_ready_signal = Globals.next_scene("res://scenes/main.tscn")
	loading_scene_ready_signal.connect(scene_ready)
	loading_scene_tip_label = Globals.get_loading_tip_label()
	loading_scene_tip_label.text = "Loading"
	#启动服务器后端
	Backend.start()
	var state = Backend.State.Executing
	
	while state == Backend.State.Executing:
		state = Backend.get_ready_state()
		pass

func scene_ready(loading_scene):
	change_scene = loading_scene.change_scene
	loading_scene_ready = true
	loading_scene_ready_signal.disconnect(scene_ready)

func _process(delta: float) -> void:
	pass
