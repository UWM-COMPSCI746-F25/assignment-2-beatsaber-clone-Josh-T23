extends Node3D

var xr_interface: XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")
		xr_interface.connect("pose_recentered", Callable(self, "_on_pose_recentered"))

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		
# Handle OpenXR pose recentered signal
func _on_pose_recentered():
	# User recentered view, we have to react to this by recentering the view.
	# This is game implementation dependent.
	#print("Player just reoriented!")
	#var origin = $XROrigin3D
	#var CubeSpawner = $%CubeSpawner
	#var camera = $%XRCamera3D
	#var directionToFace = CubeSpawner.global_position
	#await get_tree().process_frame
	#var cube = $WorldEnvironment/Blue_Box  # adjust the path if it's elsewhere

	#if not origin or not cube:
		#return
		# keep the same Y height as origin (yaw-only rotation)
	#var here = origin.global_position
	#var flat_target = Vector3(directionToFace.x, here.y, directionToFace.z)
	#var new_basis = Basis.looking_at(directionToFace, Vector3.UP)
	#origin.look_at(directionToFace)
	#camera.global_rotation.
	#self.look_at(directionToFace, Vector3.UP)
	#origin.global_position = Vector3(0,0,0)
	print("Player just reoriented!")
	await get_tree().process_frame
	await get_tree().process_frame  # ensure OpenXR finishes recentering
	
	var CubeSpawner = $%CubeSpawner
	if not CubeSpawner:
		await get_tree().process_frame
		_on_pose_recentered()
		return
	
	var origin = $XROrigin3D
	var target = CubeSpawner.global_position

	# Get current origin position
	var here = origin.global_position

	# Flatten target to same Y height (yaw rotation only)
	var flat_target = Vector3(target.x, here.y, target.z)

	print("Origin rotation degrees before:", origin.rotation_degrees)
	# Compute facing direction
	origin.look_at(flat_target, Vector3.UP)
	print("Origin rotation degrees after:", origin.rotation_degrees)
	
	print("Rotated origin toward cube:", flat_target)
