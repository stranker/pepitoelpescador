class_name LoadingScene
extends CanvasLayer

signal scene_loaded(path)

@export var progress_bar : TextureProgressBar
@export var progress_multiplier : float = 75.0

var path : String
var progress_value : float = 0

func load(path_to_load : String):
	path = path_to_load
	ResourceLoader.load_threaded_request(path)
	pass

func _physics_process(delta: float) -> void:
	if not path:
		return
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(path, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		progress_value = progress[0] * progress_multiplier
		progress_bar.value = move_toward(progress_bar.value, progress_value, delta * 20)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		progress_bar.value = move_toward(progress_bar.value, 100.0, delta * progress_multiplier * 2)
		if progress_bar.value >= 99:
			scene_loaded.emit(path)
			queue_free()
