extends Node

const SETTINGS_PATH = "user://settings.cfg"

var config := ConfigFile.new()

# Settings
var autostart_waves: bool = false

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		autostart_waves = config.get_value("gameplay", "autostart_waves", false)
	else:
		# First time running or file doesn't exist
		save_settings()

func save_settings() -> void:
	config.set_value("gameplay", "autostart_waves", autostart_waves)
	config.save(SETTINGS_PATH)

func set_autostart_waves(value: bool) -> void:
	autostart_waves = value
	save_settings()
