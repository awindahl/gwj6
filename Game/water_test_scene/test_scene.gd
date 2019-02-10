extends Spatial

onready var water = get_node("waterBody")
onready var faucet = get_node("faucet")
var faucet_pos
var water_pos
var gameOver = false
var faucetOn = true
export var waterFinalHeight = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	print(water.translation.y)
	if !gameOver:
		_checkGameCondition()
	if !faucetOn:
		_lowerWater()
	else:
		_raiseWater()


func _raiseWater():
	water.translate(Vector3(0,0.0001,0))
	
func _lowerWater():
	if water.translation.y > -1:
		water.translate(Vector3(0,-0.001,0))
	if faucet.get_node("faucetWater").translation.y > -5:
		faucet.get_node("faucetWater").translate(Vector3(0,0.05,0))
	
func _checkGameCondition():
	#if faucet button pressed:
		#faucetOn = false
		#level cleared / exit open / condition met whatever

	if water.translation.y > waterFinalHeight:
		#cacti drowns
		gameOver = true