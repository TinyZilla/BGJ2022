extends TextureProgress

func _ready():
	value = 0.0

func _process(_delta):
	# Bout to be the shittiest code I've written this whole project
	if is_instance_valid(Globals.player):
		var player = Globals.player
		max_value = player.MAX_HEALTH
		value = lerp(value, player.health, 0.5)
