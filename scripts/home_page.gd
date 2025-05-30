extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/day.text = "DAY " + str(Global.current_day)
	$VBoxContainer/workout.text = Global.get_day_title()
	$VBoxContainer/workout_details.autowrap_mode = TextServer.AUTOWRAP_WORD
	$VBoxContainer/workout_details.text = Global.get_day_details()
	var current_day = Global.current_day
	var percentage = float(current_day - 1) / 364.0 * 100.0
	$VBoxContainer/MarginContainer2/ProgressBar.value = percentage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
