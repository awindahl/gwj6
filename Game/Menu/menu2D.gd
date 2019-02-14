extends Control

onready var main = get_node("main")
onready var options = get_node("options")
onready var credits = get_node("credits")

func _ready():
	pass # Replace with function body.

func _on_playBtn_pressed():
	transition.fade_to("res://Levels/Level1.tscn", 0.9, "startSlide")

func _on_creditsBtn_pressed():
	main.hide()
	credits.show()

func _on_optionsBtn_pressed():
	main.hide()
	options.show()
	
func _on_quitBtn_pressed():
	get_tree().quit()

func _on_backBtn_pressed():
	main.show()
	options.hide()
	credits.hide()
	
	
### OPTIONS FUNCTIONALITY
func _on_fullscrnBtn_pressed():
	OS.set_window_resizable(true)
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)

func _on_toggleAimBtn_pressed():
	pass #Toggle global var for AimBtn here


func _on_muteBtn_pressed():
	pass #Toggle sound preferences here




### CREDITS FUNCTIONALITY

