extends Spatial

var BULLET_SPEED = 70

const KILL_TIMER = 4
var timer = 0
var forward_dir

func _ready():
	$Area.connect("body_entered", self, "_collided")
	forward_dir = get_parent().get_node("Player/CameraTarget/Yaw/FPSCamera/RayCast").get_global_transform().basis.z.normalized()

func _physics_process(delta):
	global_translate(forward_dir * BULLET_SPEED * delta)
	timer += delta
	if timer >= KILL_TIMER:
		queue_free()
		pass

func _collided(body):
	$hit.play(0)
	if body.get("TYPE") != "PLAYER":
		queue_free()
	pass

func _on_Area_body_entered(body):
	$hit.play(0)
	if body.get("TYPE") == "ENEMY":
		body._bullet_hit()