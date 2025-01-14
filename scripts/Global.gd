extends Node

var current_scene_state = null
var paused: bool = false
var pause_menu = null
var cat_counter = 0
var life = 5
var globalLife = 5

func set_paused(is_paused):
	paused = is_paused
