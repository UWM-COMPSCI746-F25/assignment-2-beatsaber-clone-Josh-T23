extends RigidBody3D

const VELOCITY = 1.5

func _ready():
	freeze = true

func _physics_process(delta):
	if global_position.z >= 3:
		queue_free()
	global_position.z += delta * VELOCITY
	#apply_central_force(transform.basis.z * -2)
