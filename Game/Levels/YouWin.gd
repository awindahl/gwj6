extends Spatial

func _on_Button_pressed():
	$CanvasLayer/RichTextLabel.visible = false
	$CanvasLayer/RichTextLabel2.visible = false
	$CanvasLayer/Button.visible = false
	transition.fade_to("res://Menu/menu2D.tscn", 0.9, "startSlide")