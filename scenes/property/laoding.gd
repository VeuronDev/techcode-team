extends Control

@onready var bar: ProgressBar = $ProgressBar
var progress := 0.0
func _ready():
	bar.value = 0
	progress = 0
func _process(delta):
	progress += delta * 40
	bar.value = progress
	if progress >= 100:
		if GlobalVar.is_loading:
			var path_scene = GlobalVar.get_island_scene_path()
			get_tree().change_scene_to_file(path_scene)
			GlobalVar.is_loading = false
		else:
			get_tree().change_scene_to_file("res://scenes/property/rest_area.tscn")
