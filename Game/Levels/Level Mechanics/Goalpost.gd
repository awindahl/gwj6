extends Spatial

func _on_Area_body_entered(body):
	if body.get("TYPE") == "PLAYER":
		body.levelComplete = true
		body.get_node("MeshInstance").get_node("AnimationPlayer").stop(true)
		print("you win")