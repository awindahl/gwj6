extends RigidBody

onready var water = get_parent().get_node("waterBody")
var sinking = false

func _ready():
	print("water level:" + str(to_global(Vector3(0,water.translation.y,0)).y))
	print("pool level:" + str(to_global(Vector3(0,self.translation.y,0)).y))

func _process(delta):
	if !sinking && to_global(Vector3(0,water.translation.y,0)) > to_global(Vector3(0,self.translation.y,0)):
		sinking = true

	if sinking:
		self.translate(Vector3(0,-0.05,0))
