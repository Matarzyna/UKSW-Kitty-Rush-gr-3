extends Node

var current_scene_state: Node = null
var paused: bool = false
var pause_menu = null

func set_paused(is_paused):
	paused = is_paused
