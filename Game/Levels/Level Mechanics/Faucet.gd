extends Spatial

func _close():
	var player = get_parent().get_parent().get_node("Player")
	player.cutsceneIsPlaying = true
	$AnimationPlayer2.play("Off")
	$off.play(0)

func _done():
	get_parent().get_parent().get_node("Player").cutsceneIsPlaying = false