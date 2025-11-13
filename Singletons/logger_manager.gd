# logger.gd
extends Node

enum LogLevel {DEBUG, INFO, WARNING, ERROR}

# Constants for padding
const LEVEL_PAD = 7 # Length of longest level name ("WARNING")
const SCRIPT_PAD = 20 # Adjust this based on your longest script name

var current_level = LogLevel.DEBUG


func debug(message: String, context: String = "") -> void:
    if current_level <= LogLevel.DEBUG:
        if context == "":
            context = _get_context()
        _log_message("DEBUG", message, context)


func info(message: String, context: String = "") -> void:
    if current_level <= LogLevel.INFO:
        if context == "":
            context = _get_context()
        _log_message("INFO", message, context)


func warning(message: String, context: String = "") -> void:
    if current_level <= LogLevel.WARNING:
        if context == "":
            context = _get_context()
        _log_message("WARNING", message, context)


func error(message: String, context: String = "") -> void:
    if current_level <= LogLevel.ERROR:
        if context == "":
            context = _get_context()
        _log_message("ERROR", message, context)


func _get_context() -> String:
    var stack = get_stack()
    if stack.size() > 1:
        var caller = stack[2]
        var script_name = caller["source"].get_file().get_basename()
        var line = caller["line"]
        return "%s:%d" % [script_name, line]
    return ""


func _log_message(level: String, message: String, context: String) -> void:
    var timestamp = Time.get_datetime_string_from_system()
    # Pad the level name
    var level_padded = level.left(LEVEL_PAD).lpad(LEVEL_PAD)
    # Pad the context
    var context_padded = context.left(SCRIPT_PAD).lpad(SCRIPT_PAD)
    print("%s [%s] [%s]: %s" % [timestamp, level_padded, context_padded, message])
