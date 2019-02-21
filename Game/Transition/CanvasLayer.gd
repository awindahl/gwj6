extends CanvasLayer

var path = ""
var time = 1.0

func fade_to(scn_path, scn_time = 1.0, specific_animation = "startFade"):
	for i in get_tree().get_root().get_children():
		if i.get_name() != "transition":
			i.get_tree().set_pause(true)
			break

	path = scn_path
	time = scn_time
	if $AnimationPlayer.has_animation(specific_animation):
		$AnimationPlayer.play(specific_animation, -1, time)
	else:
		print("failed transition - reverting")
		for i in get_tree().get_root().get_children():
			if i.get_name() != "transition":
				i.get_tree().set_pause(false)
				break

func change_scene():
	if path != "":
		get_tree().change_scene(path)
		for i in get_tree().get_root().get_children():
			if i.get_name() != "transition":
				i.get_tree().set_pause(false)
				break