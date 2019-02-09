extends KinematicBody
const ACCELERATION = 0.5
const DECELERATION = 0.5
const MAXSLOPEANGLE = 60
const JUMP = 20

var Gravity = -70
var WalkSpeed = 20
var SprintSpeed = 25
var MoveSpeed = WalkSpeed
var Velocity = Vector3()
var CanJump = true
var NewAngle = 0
var ShouldRotateLeft = false
var ShouldRotateRight = false

var Up
var Down
var Left
var Right
var Jump
var CameraDirection
var CameraRotation
var Normal
var Direction2d
var Direction3d
var PlayerLook
var RotLeft
var RotRight

func _physics_process(delta):
	
	# Apply Floor Normal
	if $FloorRay.is_colliding():
		Normal = $FloorRay.get_collision_normal()
	else:
		Normal = Vector3(0,0,0)
	
	if Normal.y > 0:
		CanJump = true
	else:
		_apply_gravity(delta)
	
	# Camera Controls
	## Inputs
	if not ShouldRotateLeft and not ShouldRotateRight:
		RotLeft = Input.is_action_just_pressed("RotateLeft")
		RotRight = Input.is_action_just_pressed("RotateRight")
	
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
	
	if floor(rotation_degrees.y) == floor(NewAngle):
		ShouldRotateLeft = false
		ShouldRotateRight = false
	
	# Movement and Acceleration
	## Inputs
	Up = Input.is_action_pressed("ui_up")
	Down = Input.is_action_pressed("ui_down")
	Left = Input.is_action_pressed("ui_left")
	Right = Input.is_action_pressed("ui_right")
	Jump = Input.is_action_pressed("Jump")
	
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
	
	if not ShouldRotateRight and not ShouldRotateLeft:
		Velocity = move_and_slide(Velocity, Normal)
	
func _apply_gravity(delta):
	Velocity.y += delta * Gravity
