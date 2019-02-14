extends Spatial

func _close():
	get_parent().get_node("Player").cutsceneIsPlaying = true
	$AnimationPlayer2.play("Off")

func _done():
	get_parent().get_node("Player").cutsceneIsPlaying = false