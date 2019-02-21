extends Spatial

onready var water = get_parent().get_node("waterBody")

func _ready():
	pass

func _process(delta):
	#if touching water - buoyancy - Dont know if this is actually needed or not
	if to_global(Vector3(0,water.translation.y,0)) > to_global(Vector3(0,self.translation.y,0)):
		self.translate(Vector3(0,0.01,0))
		#calculate up
		#push up
