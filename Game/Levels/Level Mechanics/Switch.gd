extends Spatial

## Sync this with the door you want to connect to
export var connectedTo = 0
const TYPE = "SWITCH"
var temp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body.get("TYPE") == "PLAYER":
		$AnimationPlayer.play("Lower")
		if temp == 0:
			body.cutsceneIsPlaying = true
			get_parent().get_node("Gate" + var2str(connectedTo))._open()
			temp = 1
			
