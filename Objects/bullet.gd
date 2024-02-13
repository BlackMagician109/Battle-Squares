extends CharacterBody2D

const SPEED = 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bullet_direction : Vector2

func _ready():
	bullet_direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
	
	velocity = SPEED * bullet_direction

	move_and_slide()
