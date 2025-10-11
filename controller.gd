extends XRController3D
# SET UP LASER IN THIS SCRIPT
var grabbed_object = null
var collided_area = null

var last_pos = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
	last_pos = global_position

func _process(delta):
	if grabbed_object:
		grabbed_object.global_position = global_position
	
	velocity = (global_position - last_pos)/delta
	last_pos = global_position

func _on_area_3d_area_entered(area):
	collided_area = area


func _on_area_3d_area_exited(area):
	collided_area = null


func _on_button_pressed(name):
	if name == "grip_click":
		if collided_area:
			grabbed_object = collided_area


func _on_button_released(name):
	if name == "grip_click":
		if grabbed_object:
			grabbed_object.apply_force(velocity * 100)
			grabbed_object = null
