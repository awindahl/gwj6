extends CanvasLayer


func _on_MainMenuButton_pressed():
	$Layer1/Layer2.visible = false
	transition.fade_to("res://Menu/menu2D.tscn", 0.9, "startSlide")

func _on_NextLevelButton_pressed():
	transition.fade_to("res://Levels/Level2.tscn", 0.9, "startSlide")