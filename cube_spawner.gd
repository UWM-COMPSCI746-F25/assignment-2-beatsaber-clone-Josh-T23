extends CSGBox3D

#var boxes = [preload("res://Boxes/blue_box.tscn"), preload("res://Boxes/red_box.tscn")]
@onready var scene_root = get_tree().root
@onready var timer = $Timer
var debounce = false
# Counter is used to ensure name is unique for laser purposes
var counter = 0

# We are going to randomly generate a blue box and red box by accessing the boxes array above
func _process(delta):
	if not debounce: return
	debounce = true
	var index = randi_range(0,1)
	var box
	if index == 0:
		box = preload("res://Boxes/blue_box.tscn").instantiate()
		box.name = "Blue_Box" + str(counter)
	else:
		box = preload("res://Boxes/red_box.tscn").instantiate()
		box.name = "Red_Box" + str(counter)
	counter += 1
	box.position = Vector3( self.position.x + randf_range(-0.75, 0.75), 
	0.6 + randf_range(0, 0.15), 
	self.position.z + randf_range(-0.5, 0.25))
	scene_root.add_child(box)
	debounce = false
	#print("hello")


func _on_timer_timeout():
	#print("Timer ran out and restarting.")
	timer.wait_time = randf_range(0.5, 2.0)
	debounce = true
