class_name Physics

static var g = 9.8


static func convert_rad_omega_to_deg(omega: float):
	return omega * 360 / (2 * PI)


static func screen_to_world_point(camera: Camera2D):
	var viewport = camera.get_viewport_rect().size
	var mouse_pos = camera.get_viewport().get_mouse_position()
	mouse_pos.y += 16

	var x_offset = mouse_pos.x - viewport.x / 2
	var y_offset = mouse_pos.y - viewport.y / 2

	return Vector2(camera.position.x + x_offset, camera.position.y + y_offset)
