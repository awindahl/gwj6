extends Spatial

class_name Enemy

var player_found : = false
var was_player_rooted : = false
enum {STATE_PATROL, STATE_ATTACK}
var state = STATE_PATROL
var shooting = false
export var SPEED : = 3.0
export var FOV : = 90.0
export var DETECT_RADIUS : = 20.0
export var DETECT_ROOTED_RADIUS : = 5.0
export var BULLET_FORCE = 5.0

onready var level : Node = get_tree().get_root().get_node("TestLevel")
onready var player : KinematicBody = level.get_node("Player")
onready var path_follow = get_parent()

#func initialise(_level : Node, _player : KinematicBody) -> void:
#	level = _level
#	player = _player

func _physics_process(delta) -> void:
	var player_distance = can_see_entity(player)
	var player_found_yet = not is_nan(player_distance)
	if player.IsRooted:
		player_found_yet = player_found_yet and player_distance < DETECT_ROOTED_RADIUS
		
	if state == STATE_PATROL:
		$GunTimer.stop()
		shooting = false
		if player_found_yet and not player_found:
			if player.IsRooted:
				print("Hey...something's quite not right here!")
				state = STATE_ATTACK
			elif not player.IsRooted:
				print("Stop right there criminal scum!")
				state = STATE_ATTACK
		
		# Enables guard to follow path
		if not player_found_yet:
			get_parent().set_offset(get_parent().get_offset() + SPEED * delta)
	elif state == STATE_ATTACK:
		# Rotate to player to shoot
		if player_found_yet:
			var LastRot = path_follow.rotation_degrees
			var value = 0.2
			value += delta
			var LookDir = (player.global_transform.origin - path_follow.global_transform.origin) * -1
			var RotTrans = path_follow.global_transform.looking_at(path_follow.global_transform.origin + LookDir, Vector3 (0,1,0))
			var ThisRot = Quat(path_follow.global_transform.basis).slerp(RotTrans.basis, value)
			ThisRot.normalized()
			if value > 1:
				value = 1
			path_follow.set_transform(Transform(ThisRot, path_follow.translation))
			path_follow.rotation_degrees.x = LastRot.x
			
		if not shooting:
			$GunTimer.start()
			shooting = true
			
		if not was_player_rooted and player.IsRooted and player_found:
			print("I can still see you...")
		elif not player_found_yet and player_found:
			print("Must have been the wind...")
			state = STATE_PATROL
		
	player_found = player_found_yet
	was_player_rooted = player.IsRooted
	
func can_see_entity(entity) -> float:
	# Returns a float with distance away from object, if it can be seen by the bandit.
		
	var direction = entity.global_transform.origin - $RayCast.global_transform.origin
	var distance = direction.length()
	if distance < DETECT_RADIUS:
		var angle_to_player = rad2deg((global_transform.basis.z).angle_to(direction.normalized()))
		if abs(angle_to_player) < FOV/2:
			$RayCast.cast_to = direction.rotated(Vector3(0,-1,0), path_follow.rotation.y)
			if $RayCast.is_colliding() and $RayCast.get_collider() == entity:
				return distance
	return NAN

func shoot(entity) -> void:
	entity.knockback(self, BULLET_FORCE)

func _on_GunTimer_timeout():
	shoot(player)
	shooting = false
