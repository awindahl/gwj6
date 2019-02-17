extends Control

onready var main = get_node("main")
onready var options = get_node("options")
onready var credits = get_node("credits")
onready var window = get_node("Sprite")
onready var sizeBtn = get_node("options/sizeBtn")

var screenDict = {
	"960×540": Vector2(960,540),\
	"1024x576": Vector2(1024,576),\
	"1280×720": Vector2(1280,760),\
	"1600×900": Vector2(1600,900),\
	"1920×1080": Vector2(1920,1080),\
	"2560×1440": Vector2(2560,1440),\
	"3840×2160": Vector2(3840,2160)}

var screen_size
var scale

func _ready():
	screen_size = get_viewport().size #starting size. should be engine default 1024x576 unless we save data in the future
	scale = window.scale 			  #starting scale of 3d sprite
	
	sizeBtn.add_item("960×540")
	sizeBtn.add_item("1024x576")
	sizeBtn.add_item("1280×720")
	sizeBtn.add_item("1600×900")
	sizeBtn.add_item("1920×1080")
	sizeBtn.add_item("2560×1440")
	sizeBtn.add_item("3840×2160")
	sizeBtn.select(1)

func _on_playBtn_pressed():
	$desertStream.playing = false
	$musicstream.playing = false
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

func _on_desertStream_finished():
	$desertStream.play(0)

func _on_musicstream_finished():
	$musicstream.play(0)

# =================================================== OPTIONS FUNCTIONALITY ===================================================
func _on_fullscrnBtn_pressed():
	OS.set_window_resizable(true)
	if OS.is_window_fullscreen():
		sizeBtn.disabled = false
		OS.set_window_fullscreen(false)
		scale = window.scale * screen_size/OS.get_screen_size()
		window.scale = scale
	else:
		sizeBtn.disabled = true
		OS.set_window_fullscreen(true)
		scale = window.scale * OS.get_screen_size()/screen_size
		window.scale = scale
func _on_toggleAimBtn_pressed():
	pass #Toggle global var for AimBtn here


func _on_muteBtn_pressed():
	pass #Toggle sound preferences here

func _on_sizeBtn_item_selected(ID):
	var temp_size
	match ID:
		0:
			temp_size = screenDict["960×540"]
		1:
			temp_size = screenDict["1024x576"]
		2:
			temp_size = screenDict["1280×720"]
		3:
			temp_size = screenDict["1600×900"]
		4:
			temp_size = screenDict["1920×1080"]
		5:
			temp_size = screenDict["2560×1440"]
		6:
			temp_size = screenDict["3840×2160"]
	
	if screen_size != temp_size:
		scale = window.scale * (temp_size/screen_size)
		screen_size = temp_size
		window.scale = scale
		OS.set_window_size(screen_size)

# =================================================== CREDITS FUNCTIONALITY ===================================================
