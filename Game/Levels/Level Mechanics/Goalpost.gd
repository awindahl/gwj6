extends Spatial

func _on_Area_body_entered(body):
	if body.get("TYPE") == "PLAYER":
		if body.waterOff == true:
			print("A")
			body.levelComplete = true
			body.get_node("walk").stop()
			body.get_node("MeshInstance").get_node("AnimationPlayer").stop(true)