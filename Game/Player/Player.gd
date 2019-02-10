extends KinematicBody

# Constants
const ACCELERATION = 0.5
const DECELERATION = 0.5
const MAXSLOPEANGLE = 60
const JUMP = 20

# Assigned vars, export some of these
export var Gravity = -70
export var WalkSpeed = 20
export var SprintSpeed = 25
var MoveSpeed = WalkSpeed
var Velocity = Vector3()
var CanJump = true
var NewAngle = 0
var ShouldRotateLeft = false
var ShouldRotateRight = false
var IsRooted = true

# Indetermined vars
var Up
var Down
var Left
var Right
var Space
var Normal
var Direction2d
var Direction3d
var RotLeft
var RotRight

func _physics_process(delta):
	
	_rotation_process()
	_movement_process(delta)
	_root()
	
	# You can only jump if you are touching the floor
	if _get_normal().y > 0:
		CanJump = true
	else:
		_apply_gravity(delta)
	

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
	if not ShouldRotateLeft and not ShouldRotateRight:
		RotLeft = Input.is_action_just_pressed("RotateLeft")
		RotRight = Input.is_action_just_pressed("RotateRight")
	
	# Make sure you can only rotate in one direction once
	## TODO Camera Acceleration?
	if RotLeft and not ShouldRotateLeft and not RotRight:
		NewAngle = floor(rotation_degrees.y + 90)
		ShouldRotateLeft = true
	if RotRight and not ShouldRotateRight and not RotLeft:
		NewAngle = floor(rotation_degrees.y - 90)
		ShouldRotateRight = true
	
	if ShouldRotateLeft and rotation_degrees.y != NewAngle:
		rotation_degrees.y = round(rotation_degrees.y + 1)
	if ShouldRotateRight and rotation_degrees.y != NewAngle:
		rotation_degrees.y = round(rotation_degrees.y - 1)
	
	# Stop rotating !!
	if floor(rotation_degrees.y) == floor(NewAngle):
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
	if Up:
		Direction2d.y += 1
	if Down:
		Direction2d.y -= 1
	if Left:
		Direction2d.x += 1
	if Right:
		Direction2d.x -= 1
	
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
	
	# Only move if camera is not rotating and not rooted
	if not ShouldRotateRight and not ShouldRotateLeft and not IsRooted:
		Velocity = move_and_slide(Velocity, _get_normal())

func _root():
	# Root/Uproot Mechanic
	Space = Input.is_action_just_pressed("Space")
	if Space and IsRooted:
		IsRooted = false
	elif Space and not IsRooted:
		IsRooted = true

func _shoot():
	pass