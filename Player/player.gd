extends CharacterBody3D
@onready var camera_pivot: Node3D = $CameraPivot
@export var SPEED = 1.5
@export var jump_height = 1.5
var mouse_motion := Vector2.ZERO
var stamina = 100
var stamina_full:bool = true
var walk_speed := 1.5
var run_speed := 5
var drain_speed := 5
var recharge_speed := 10
var wait_time = 2.0
var exhausted:bool = false
func _running(delta) -> void:
	print("running")
	SPEED = run_speed
	stamina -= drain_speed * delta
	wait_time = 2.0
func _walking(delta, input_dir) -> void:
	if input_dir.length() > 0:
		print("walking")
	else:
		print("standing")
	SPEED = 1.5
	wait_time -= delta
func _recharge(delta) -> void:
	if stamina == 0:
		print("exhausted")
	stamina += recharge_speed * delta
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta: float) -> void:
	handle_camera_rotation()
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("Jump") and is_on_floor() and stamina >= 50 and exhausted == false:
		velocity.y = sqrt( jump_height * 2.0 * 9.81)
		stamina -= 50
	var input_dir := Input.get_vector("MoveL", "MoveR", "MoveUp", "MoveDo")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if stamina <= 0:
		exhausted = true
	if stamina == 100:
		exhausted = false
	if Input.is_action_pressed("shift") and input_dir.length() > 0 and exhausted == false:
		_running(delta)
	else:
		_walking(delta,input_dir)
		if wait_time <= 0 and stamina < 100:
			_recharge(delta)
	stamina = clamp(stamina, 0, 100)
	if direction:
		velocity.x = direction.x * SPEED 
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
	if Input.is_action_just_pressed("close"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("enter"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0)
	mouse_motion = Vector2.ZERO		
	

	
