extends Control

export(float) var move_speed = 0.1
export(float) var rotation_speed = 0.1
export(float) var move_strength = 5.0
export(float) var rotation_strength = 0.6

var noise : OpenSimplexNoise = OpenSimplexNoise.new()
var start_position : Vector2

onready var center_container = $CenterContainer

func _ready():
	noise.octaves = 1
	start_position = center_container.rect_position

func _process(_delta):
	var time : float = OS.get_ticks_msec()
	var offset : float = noise.get_noise_2d(time * move_speed, time * move_speed)
	var rotation : float = noise.get_noise_1d(-time * rotation_speed)
	center_container.rect_position = start_position + Vector2(offset, offset) * move_strength
	center_container.rect_rotation = rotation * rotation_strength

