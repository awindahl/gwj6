extends KinematicBody

# Constants
const ACCELERATION = 0.5
const DECELERATION = 0.5
const MAXSLOPEANGLE = 30
const JUMP = 20
const TYPE = "PLAYER"

# Assigned vars, export some of these
export var Gravity = -40
export var WalkSpeed = 10
export var NumberOfNeedles = 1
export var IsRooted = true
export var health = 2

var MoveSpeed = WalkSpeed
var Velocity = Vector3()
var CanClimb = true
var NewAngle = 0
var ShouldRotateLeft = false
var ShouldRotateRight = false
var Needle = preload ("res://Player/Needle.tscn")
var IsZoomed = false
var IsMoving = false
var Yaw = 0
var Pitch = 0
var ViewSensitivity = 0.5
var CanMoveMouse = false
var IsClimbing = false
var cutsceneIsPlaying = false
var canRoot = true
var temp = 0
var isAlive = true
var levelComplete = false
var waterOff = false

# Indetermined vars
var Up
var Down
var Left
var Right
var Space
var Normal
var Click
var Climb
var JustClick
var JustClickReleased
var Direction2d
var Direction3d
var RotLeft
var RotRight
var Body
var Turn
var isPlaying 

var waterFinished = true

func _ready():
	$CameraTarget/ThirdPerson/TPCamera.make_current()

func _physics_process(delta):
	
	if isAlive and not levelComplete:
		
		if not cutsceneIsPlaying:
			_rotation_process()
			_movement_process(delta)
			_root()
			_shoot()
			_climb()
			_looking_at()
			_ui_handler()
			
	if levelComplete:
		$CanvasLayer/Layer1.visible = false
			
		# You can only jump if you are touching the floor
	if not $FloorRay.is_colliding():
		_apply_gravity(delta)
	if IsRooted:
		Velocity.y = 0

func _apply_gravity(delta):
	Velocity.y += delta * Gravity

func _get_normal():
	# Apply Floor Normal
	if $FloorRay.is_colliding():
		Normal = $FloorRay.get_collision_normal()
	else:
		Normal = Vector3(0,0,0)
	
	return Normal

func _rotation_process():
	# Camera Controls
	## Inputs
	if not ShouldRotateLeft and not ShouldRotateRight and not IsZoomed:
		RotLeft = Input.is_action_just_pressed("RotateLeft")
		RotRight = Input.is_action_just_pressed("RotateRight")
	
	# Make sure you can only rotate in one direction once
	## TODO Camera Acceleration?
	if RotLeft and not ShouldRotateLeft and not RotRight:
		NewAngle = round(rotation_degrees.y + 90.0)
		ShouldRotateLeft = true
	if RotRight and not ShouldRotateRight and not RotLeft:
		NewAngle = round(rotation_degrees.y - 90.0)
		ShouldRotateRight = true
	
	if ShouldRotateLeft and rotation_degrees.y != NewAngle:
		$MeshInstance.rotation_degrees.y = 0
		rotation_degrees.y = round(rotation_degrees.y + 3.0)
	if ShouldRotateRight and rotation_degrees.y != NewAngle:
		$MeshInstance.rotation_degrees.y = 0
		rotation_degrees.y = round(rotation_degrees.y - 3.0)
	
	# Stop rotating !!
	if round(rotation_degrees.y) == round(NewAngle):
		ShouldRotateLeft = false
		ShouldRotateRight = false

func _movement_process(delta):
		# Movement and Acceleration
	## Inputs
	Up = Input.is_action_pressed("ui_up")
	Down = Input.is_action_pressed("ui_down")
	Left = Input.is_action_pressed("ui_left")
	Right = Input.is_action_pressed("ui_right")
	
	# Set general direction vector in 2 dimensions, then translate to 3d to keep the player forward as "true forward"
	Direction2d = Vector2()
	Direction3d = Vector3()
	if Up and not IsZoomed and not cutsceneIsPlaying:
		IsMoving = true
		Direction2d.y += 1
		$MeshInstance.rotation_degrees.y = 0
	if Down and not IsZoomed and not cutsceneIsPlaying:
		IsMoving = true
		Direction2d.y -= 1
		$MeshInstance.rotation_degrees.y = 180
	if Left and not cutsceneIsPlaying:
		IsMoving = true
		Direction2d.x += 1
		if not IsZoomed:
			$MeshInstance.rotation_degrees.y = 90
	if Right and not cutsceneIsPlaying:
		IsMoving = true
		Direction2d.x -= 1
		if not IsZoomed:
			$MeshInstance.rotation_degrees.y = -90
	
	if not Up and not Down and not Left and not Right:
		IsMoving = false
		#Velocity = Vector3(0,0,0)
		if temp == 0:
			isPlaying = false
			_play_anim("idle_anim")
			$walk.stop()
			temp = 1
	
	if IsMoving and temp == 1 and not IsRooted:
		isPlaying = false
		temp = 0
		_play_anim("walk_anim")
		if !canRoot:
			if waterFinished:
				$water_walk.play(0)
		else:
			$walk.play(0)
			if waterFinished:
				$water_walk.stop()
	
	Direction2d = Direction2d.normalized()
	Direction3d += global_transform.basis.z.normalized() * Direction2d.y
	Direction3d += global_transform.basis.x.normalized() * Direction2d.x
	
	## Acceleration and Retardation
	var hVel = Velocity
	hVel.y = 0
	var Target = Direction3d * MoveSpeed
	var Acceleration
	if Direction3d.dot(hVel) > 0:
		Acceleration = ACCELERATION
	else:
		Acceleration = DECELERATION
	
	hVel = hVel.linear_interpolate(Target, Acceleration * MoveSpeed * delta)
	Velocity.x = hVel.x
	Velocity.z = hVel.z
	
	# Only move if camera is not rotating and not rooted and not zoomed
	if not ShouldRotateRight and not ShouldRotateLeft and not IsRooted and (not IsZoomed or CanMoveMouse) and not cutsceneIsPlaying:
		Velocity = move_and_slide(Velocity, _get_normal(), 0.05, 4 ,deg2rad(MAXSLOPEANGLE))
		IsMoving = true
	
func _root():
	# Root/Uproot Mechanic
	Space = Input.is_action_just_pressed("Space")
	if Space and IsRooted:
		IsRooted = false
		$CanvasLayer/Layer1/Rooted.visible = false
		$root.play(0)
	elif Space and not IsRooted and not ShouldRotateLeft and not ShouldRotateRight and not IsZoomed and not IsClimbing and canRoot and $FloorRay.is_colliding():
		IsRooted = true
		$CanvasLayer/Layer1/Rooted.visible = true
		$root.play(0)
	
func _shoot():
	# Switch Camera to FPS when shooting
	## Input
	if not ShouldRotateLeft and not ShouldRotateRight:
		JustClick = Input.is_action_just_pressed("RightClick")
		JustClickReleased = Input.is_action_just_released("RightClick")
		
	## Handle switching between cameras
	if $AnimationPlayer.is_playing() == false and IsZoomed == true:
		$CameraTarget/Yaw/FPSCamera.make_current()
		CanMoveMouse = true
	elif not IsZoomed and not cutsceneIsPlaying:
		$CameraTarget/ThirdPerson/TPCamera.make_current()
		CanMoveMouse = false
	
	if JustClick and not IsZoomed:
		$MeshInstance.rotation_degrees.y = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$AnimationPlayer.play("CameraMove")
		IsZoomed = true
		$CameraTarget/Yaw/FPSCamera/Crosshair.visible = true
		
	if JustClickReleased:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$AnimationPlayer.play_backwards("CameraMove")
		IsZoomed = false
		$CameraTarget/Yaw/FPSCamera/Crosshair.visible = false
		$CameraTarget/Yaw/FPSCamera/Arm.visible = false
		$MeshInstance.visible = true
		CanMoveMouse = false
		Yaw = 0
		Pitch = 0
		$CameraTarget/Yaw.rotation = Vector3()
	
	## Shoot needle
	if CanMoveMouse:
		Click = Input.is_action_just_pressed("LeftClick")
		$CameraTarget/Yaw/FPSCamera/Arm.visible = true
		$MeshInstance.visible = false
		if Click and NumberOfNeedles != 0:
			$shoot.play(0)
			NumberOfNeedles -= 1
			var NewNeedle = Needle.instance()
			get_parent().add_child(NewNeedle)
			NewNeedle.global_transform = $CameraTarget/Yaw/FPSCamera/RayCast.global_transform
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and CanMoveMouse:
		Yaw = max(min(Yaw - event.relative.x * ViewSensitivity,80), -80)
		Pitch = max(min(Pitch - event.relative.y * ViewSensitivity, 80), -80)
		$CameraTarget/Yaw.rotation = Vector3(0, deg2rad(Yaw), 0)
	$CameraTarget/Yaw/FPSCamera.rotation = Vector3(deg2rad(Pitch), 0, 0)

func _climb():
	## Inputs
	if CanClimb:
		Climb = Input.is_action_just_pressed("Climb")
	
	## LEARN HOW TO USE FSMS FUCKS SAKE MAN
	if _climb_check() and \
	Climb and \
	not IsZoomed and \
	not IsRooted and \
	not ShouldRotateLeft and \
	not ShouldRotateRight and \
	(Up or \
	Down or \
	Left or \
	Right):
		isPlaying = false
		_play_anim("climb_anim")
		IsMoving = true
		temp = 1
		Velocity.y += 10
		Velocity += global_transform.basis.z.normalized() * Direction2d.y
		Velocity += global_transform.basis.x.normalized() * Direction2d.x

func _climb_check():
	if $MeshInstance/ClimbRays/Bottom.is_colliding() and not $MeshInstance/ClimbRays/Top.is_colliding():
		return 1
	else:
		return 0

func knockback(source : Spatial, force : float) -> void:
	$hurt.play(0)
	var direction = global_transform.origin - source.global_transform.origin
	Velocity += direction*force
	health -= 1
	if health == 0:
		_die()

func _die():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	IsZoomed = false
	$CameraTarget/Yaw/FPSCamera/Crosshair.visible = false
	$CameraTarget/Yaw/FPSCamera/Arm.visible = false
	$MeshInstance.visible = true
	CanMoveMouse = false
	$MeshInstance/AnimationPlayer.play("death_anim")
	isAlive = false
	$RespawnTimer.start()

	
func _looking_at():
	## Inputs
	Turn = Input.is_action_pressed("Turn")
	if $MeshInstance/FaceRay.is_colliding():
		Body = $MeshInstance/FaceRay.get_collider()
		if Body.get("TYPE") == "VALVE":
			if Turn:
				get_parent().get_node("Mechanics/Faucet")._close()
				waterOff = true

func _play_anim(anim):
	if not isPlaying:
		$MeshInstance/AnimationPlayer.play(anim)
		isPlaying = true

func _on_water_walk_finished():
	waterFinished = true

func _ui_handler():
	if health == 0:
		$CanvasLayer/Layer1/Health1.visible = false
		$CanvasLayer/Layer1/Health2.visible = false
	if health == 1:
		$CanvasLayer/Layer1/Health1.visible = true
		$CanvasLayer/Layer1/Health2.visible = false
	if health == 2:
		$CanvasLayer/Layer1/Health1.visible = true
		$CanvasLayer/Layer1/Health2.visible = true
	
	if NumberOfNeedles == 0:
		$CanvasLayer/Layer1/Needle1.visible = false
		$CanvasLayer/Layer1/Needle2.visible = false
		$CanvasLayer/Layer1/Needle3.visible = false
	if NumberOfNeedles == 1:
		$CanvasLayer/Layer1/Needle1.visible = true
		$CanvasLayer/Layer1/Needle2.visible = false
		$CanvasLayer/Layer1/Needle3.visible = false
	if NumberOfNeedles == 2:
		$CanvasLayer/Layer1/Needle1.visible = true
		$CanvasLayer/Layer1/Needle2.visible = true
		$CanvasLayer/Layer1/Needle3.visible = false
	if NumberOfNeedles == 3:
		$CanvasLayer/Layer1/Needle1.visible = true
		$CanvasLayer/Layer1/Needle2.visible = true
		$CanvasLayer/Layer1/Needle3.visible = true

func _on_AmmoRefresh_timeout():
	if NumberOfNeedles < 3:
		NumberOfNeedles += 1
		
func _restart():
	transition.fade_to("res://Levels/GameOver.tscn", 0.9, "startSlide")

func _on_RespawnTimer_timeout():
	_restart()