extends KinematicBody

class_name Enemy

var player_found : = false

export var SPEED : = 20.0
export var FOV : = 90.0
export var DETECT_RADIUS : = 20

onready var level : Node = get_tree().get_root().get_node("Level1")
onready var player : KinematicBody = level.get_node("Player")
onready var direction : = Vector3()
signal player_found

#func initialise(_level : Node, _player : KinematicBody) -> void:
#	level = _level
#	player = _player

func _physics_process(delta) -> void:
	
	
		
	# Try to find player
	direction = global_transform.origin - player.global_transform.origin
	player_found = false
	if direction.length() < DETECT_RADIUS:
		var angle_to_player = rad2deg((-global_transform.basis.z).angle_to(direction.normalized()))
		if abs(angle_to_player) < FOV/2:
			print("Stop right there criminal scum!")
			emit_signal("player_found")
			player_found = true
	
	if not player_found:
		# Follow the path around
		get_parent().set_offset(get_parent().get_offset() + 3 * delta)
	
	
	var path : Path = level.get_node("Path")
