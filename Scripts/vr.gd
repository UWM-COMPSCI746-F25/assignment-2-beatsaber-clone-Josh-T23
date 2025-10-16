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
		
# Used chatgpt to assist in developing a method that would realign the world view to headset.
# Prompts used (all on 10/15/2025):
# 1. on_post_recentered for vr project. I am using look_at on the XRcamera3D and it is moving 
# my camera up and down based on my height which is good. But it is not rotating.
# 2. You do understand what I want you to do right? I want the screen to rotate where I am 
# looking.
func _on_pose_recentered():
	print("Pose recentered! Aligning world with headset direction...")
	call_deferred("_align_world_to_headset")

func _align_world_to_headset():
	var origin = $XROrigin3D
	var camera = $XROrigin3D/XRCamera3D
	
	# Get headset's current global yaw (rotation around Y)
	var head_basis = camera.global_transform.basis
	var forward = head_basis.z
	forward.y = 0
	#forward = forward.normalized()
	
	# Compute the angle the head is currently facing
	var angle = atan2(forward.x, forward.z)
	
	# Rotate the origin (or a parent) *opposite* that yaw
	# so the direction you are looking becomes forward (Z+)
	origin.rotate_y(-angle)
	
	#print("Realigned world by", rad_to_deg(angle), "degrees")
