extends Spatial

class_name Enemy

var player_found : = false
var direction : = Vector3()
var player_found_yet

export var SPEED : = 3.0
export var FOV : = 90
export var DETECT_RADIUS : = 20

onready var player : KinematicBody = get_parent().get_parent().get_parent().get_node("Player")
onready var path_follow = get_parent()

signal player_found
signal player_lost

#func initialise(_level : Node, _player : KinematicBody) -> void:
#	level = _level
#	player = _player

func _physics_process(delta) -> void:
	
	# Try to find player
	direction = player.global_transform.origin - path_follow.global_transform.origin
	player_found_yet = false
	if direction.length() < DETECT_RADIUS:
		var angle_to_player = rad2deg((global_transform.basis.z).angle_to(direction.normalized()))
		if abs(angle_to_player) < FOV/2:
			$RayCast.cast_to = direction.rotated(Vector3(0,-1,0), path_follow.rotation.y)
			if $RayCast.is_colliding() and $RayCast.get_collider() == player:
				player_found_yet = true
		
	if player_found_yet and not player_found:
		print("Stop right there criminal scum!")
		emit_signal("player_found")
	elif not player_found_yet and player_found:
		print("Must have been the wind...")
		emit_signal("player_lost")
	
	if not player_found_yet:
		# Follow the path around
		get_parent().set_offset(get_parent().get_offset() + SPEED * delta)
		
	player_found = player_found_yet
