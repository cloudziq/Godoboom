extends Node




func window_prepare():
	var display_size = OS.get_screen_size()
	var window_size = OS.window_size
	window_size.x *= 4 ; window_size.y *= 4

	if display_size.y <= window_size.y:
		var scale_ratio = window_size.y / (display_size.y - 100)
		window_size.x /= scale_ratio ; window_size.y /= scale_ratio

	OS.set_window_size(window_size)
	window_size.y += 80
	OS.set_window_position(display_size * .5 - window_size * .5)
