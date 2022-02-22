extends Spatial

var ray_origin := Vector3.ZERO
var ray_end := Vector3.ZERO

func click_3d():
	# From some Nolkaloid vid
	var space_state : PhysicsDirectSpaceState = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	var camera : Camera = get_viewport().get_camera()
	
	ray_origin = get_viewport().get_camera().project_ray_origin(mouse_position)
	ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000.0
	
	var intersection = space_state.intersect_ray(ray_origin, ray_end)
	
	if not intersection.empty():
		var pos : Vector3 = intersection.position
		
		# Debug draw point position
		var meshi := MeshInstance.new()
		var mesh := CubeMesh.new()
		meshi.mesh = mesh
		add_child(meshi)
		meshi.global_transform.origin = pos
		
		return pos
