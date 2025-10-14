extends XRController3D

@export var raycast_length = 1
var visiblity = true
# SET UP LASER IN THIS SCRIPT
#var grabbed_object = null
#var collided_area = null
#
#var last_pos = Vector3.ZERO
#var velocity = Vector3.ZERO
#
#func _ready():
	#last_pos = global_position
#
#func _process(delta):
	#if grabbed_object:
		#grabbed_object.global_position = global_position
	#
	#velocity = (global_position - last_pos)/delta
	#last_pos = global_position

func _physics_process(delta):
	if not visiblity: return # don't run raycasting if laser is not visible
	var space_state = get_world_3d().direct_space_state
	
	var origin = global_position
	var dir = global_basis.z * -1
	var end = origin + (dir * raycast_length)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	$LineRendererRight.points[0] = origin + dir * 0.1
	$LineRendererRight.points[1] = end
	if result:
		$LineRendererRight.points[1] = result.position
		if result.collider.name == "Blue_Box":
			%SwordSwish.play()
			result.collider.queue_free()
		#print("Collider name: ", result.collider.name)
		


#func _on_area_3d_body_entered(area):
	#collided_area = area
#
#
#func _on_area_3d_body_exited(area):
	#collided_area = null

func _on_button_pressed(name):
	if name == "ax_button":
		if $LineRendererRight.transparency == 1:
			$LineRendererRight.transparency = 0
			visiblity = true
		else:
			visiblity = false 
			$LineRendererRight.points[0] = Vector3(0,0,0)
			$LineRendererRight.points[1] = Vector3(0,0,0)
			$LineRendererRight.transparency = 1
	#if name == "menu_button":
		#print("You pressed the occulus button")

#
#func _on_button_released(name):
	#if name == "grip_click":
		#if grabbed_object:
			#grabbed_object.apply_force(velocity * 100)
			#grabbed_object = null
