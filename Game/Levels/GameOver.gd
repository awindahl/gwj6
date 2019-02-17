extends Node2D

func _on_Button_pressed():
	tracker.n = 1
	transition.fade_to("res://Menu/menu2D.tscn", 0.9, "startSlide")