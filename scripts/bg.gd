extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_seconds = OS.get_ticks_usec() / 1000000.0
	material.set_shader_param("time", time_seconds)
