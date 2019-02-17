extends Spatial

var n = 0

func _on_Button_pressed():
	if n == 0:
		$CanvasLayer/RichTextLabel.text = "Controls: To uproot, press space! Use WASD to move your brave cactus agent around. You can rotate the camera with Q and E. To win, you have to turn off the pipes pumping water into the desert. Find the valve and press R, then make it to the goal post!"
	
	if n == 1:
		$CanvasLayer/RichTextLabel.text = ""
		$CanvasLayer/Button.visible = false
		transition.fade_to("res://Levels/Level1.tscn", 0.9, "startSlide")
	n += 1
	