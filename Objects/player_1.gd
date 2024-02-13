extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var bullet :PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var total_jump = 0;

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and total_jump<1:
			velocity.y = JUMP_VELOCITY
			total_jump += 1
		
		if is_on_floor():
			total_jump = 0
		
		$shooting_direction.look_at(get_global_mouse_position())
		
		if Input.is_action_just_pressed("shoot"):
			shoot.rpc()
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()

@rpc("any_peer", "call_local")
func shoot():
	var b = bullet.instantiate()
	b.global_position = $shooting_direction/spawn_bullet.global_position
	b.rotation_degrees = $shooting_direction.rotation_degrees
	get_tree().root.add_child(b)
