extends Control
@onready var progress_bar = $AspectRatioContainer/LoadingScreen/MarginContainer/VBoxContainer/ProgressBar
@onready var tip_label =$AspectRatioContainer/LoadingScreen/MarginContainer/VBoxContainer/RichTextLabel
var next_scene:String
var is_changing:bool
signal change_scene
signal scene_changed
signal scene_ready

func _ready() -> void:
	change_scene.connect(change)

func next(next_scene_path:String) -> void:
	if !next_scene_path.is_empty():
		next_scene = next_scene_path
		is_changing = true
		ResourceLoader.load_threaded_request(next_scene,"")
		
func _process(delta: float) -> void:
	if !is_changing:
		return
	var progress = []
	var loaded_status = ResourceLoader.load_threaded_get_status(next_scene,progress)
	if loaded_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		var new_progress = progress[0] * 100.0
		progress_bar.value = lerp(progress_bar.value,new_progress,delta)
	elif loaded_status == ResourceLoader.THREAD_LOAD_LOADED:
		progress_bar.value = lerpf(progress_bar.value,100.0,delta*5)
		if progress_bar.value >= 99.0:
			progress_bar.value = 100.0
			scene_ready.emit(self)


func change():
	is_changing = false
	var packed_next_scene = ResourceLoader.load_threaded_get(next_scene)
	get_tree().change_scene_to_packed(packed_next_scene)
	scene_changed.emit()
	progress_bar.value = 0.0
