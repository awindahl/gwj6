extends Spatial

export var connectedTo = 0
var temp = 0

func _ready():
	name = "Gate" + var2str(connectedTo)
	

func _open():
	if temp == 0:
		$off.play(0)
		$AnimationPlayer.play("Lower")
		get_parent().get_parent().get_node("Player/walk").stop()
		temp = 1

func _done():
	get_parent().get_parent().get_node("Player").cutsceneIsPlaying = false