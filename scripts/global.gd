extends Node

var first_open_timestamp: int
var current_day: int = 1

var workout_data = []

func _ready():
	load_or_initialize_first_open_timestamp()
	calculate_current_day()
	load_workout_data()
	
func load_workout_data():
	var file = FileAccess.open("res://data/workout_plan.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		workout_data = JSON.parse_string(text)
		if workout_data == null:
			push_error("Failed to parse workout JSON")
	else:
		push_error("Could not open workout_plan.json")

func load_or_initialize_first_open_timestamp():
	var config = ConfigFile.new()
	var path = "user://userdata.cfg"

	if config.load(path) != OK:
		# First time running the app
		first_open_timestamp = Time.get_unix_time_from_system()
		config.set_value("user", "first_open_unix", first_open_timestamp)
		config.save(path)
	else:
		first_open_timestamp = int(config.get_value("user", "first_open_unix", Time.get_unix_time_from_system()))

func calculate_current_day():
	var now = Time.get_unix_time_from_system()
	var seconds_passed = now - first_open_timestamp
	var days_passed = int(seconds_passed / (60 * 60 * 24))
	current_day = clamp(days_passed + 1, 1, 365)
	print("Current Workout Day: %d" % current_day)
	
func get_day_title() -> String:
	var entry = get_workout_entry()
	return entry.get("title", "Workout")

func get_day_details() -> String:
	var entry = get_workout_entry()
	return entry.get("description", "No description available.")

func get_workout_entry() -> Dictionary:
	for entry in workout_data:
		if entry.get("day") == current_day:
			return entry
	return {}  # fallback if not found
