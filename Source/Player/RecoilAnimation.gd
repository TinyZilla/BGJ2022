extends Spatial

onready var ap = $AnimationPlayer
onready var muzzle_flash = $MuzzleFlash

const mf_particles = preload("res://Source/Player/MuzzleFlashParticles.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("LMB"):
		ap.play("fire", -1, Globals.gun_fire_rate)
		instance_mf_particles()

func instance_mf_particles():
	var mf = mf_particles.instance()
	add_child(mf)
	mf.global_transform.origin = muzzle_flash.global_transform.origin
