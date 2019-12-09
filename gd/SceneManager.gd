extends Node

# Initialize.
var queue = preload("res://gd/ResourceQueue.gd").new()
var SceneLoading = preload("res://tscn/SceneLoading.tscn")
var current_scene
var old_path
var path
var is_loading

func _ready():
	queue.start()
	is_loading = false

func load_scene(scene_path):
	self.load_level()
	path = scene_path
	queue.queue_resource(path,true)
	is_loading = true

func _process(delta):
	if is_loading:
		if queue.is_ready(path):
			show_new_level(queue.get_resource(path))
		else:
			update_progress(queue.get_progress(path))
		
func load_level():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	current_scene.queue_free()
	self.show_new_level(SceneLoading)

func update_progress(progress):
	# Update your progress bar?
	var root = get_tree().get_root()
	var cs = root.get_child(root.get_child_count() -1)
	cs.get_node("CenterContainer/VBoxContainer/Progress").set_fill_degrees(progress)
	cs.get_node("CenterContainer/VBoxContainer/Label").text = "正在加载资源请稍后("+str(progress)+"%)"
	# ... or update a progress animation?
#	var length = get_node("animation").get_current_animation_length()
	# Call this on a paused animation. Use "true" as the second argument to force the animation to update.
#	get_node("animation").seek(progress * length, true)

func show_new_level(scene_resource):
	is_loading = false
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	if old_path:
		queue.cancel_resource(old_path)
	old_path = path

