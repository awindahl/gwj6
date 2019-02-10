extends KinematicBody

class_name Enemy

export var FOV : = 90.0
export var DETECT_RADIUS : = 20
var level : Node
var player : KinematicBody
onready var direction : = Vector3()

signal player_found

func initialise(_level : Node, _player : KinematicBody) -> void:
	level = _level
	player = _player

func _physics_process(delta) -> void:
	direction = global_transform.origin - player.global_transform.origin
	if direction.length() < DETECT_RADIUS:
		var angle_to_player = rad2deg((-global_transform.basis.z).angle_to(direction.normalized()))
		if abs(angle_to_player) < FOV/2:
			print("Stop right there criminal scum")
			emit_signal("player_found")
