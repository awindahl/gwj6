extends CanvasLayer

var n = tracker.n

func _on_MainMenuButton_pressed():
	$Layer1/Layer2.visible = false
	transition.fade_to("res://Menu/menu2D.tscn", 0.9, "startSlide")

func _on_NextLevelButton_pressed():
	tracker.n += 1
	n = tracker.n
	transition.fade_to("res://Levels/Level" + var2str(n) + ".tscn", 0.9, "startSlide")