extends Spatial

var Velocity = Vector3()
var Gravity = -70
func _ready():
	pass

func _process(delta):
	#if touching water - buoyancy
	_apply_gravity(delta)


func _apply_gravity(delta):
	Velocity.y += delta * Gravity