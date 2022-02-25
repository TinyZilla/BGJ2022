extends Spatial

func _ready():
	var lifetime : float = $Particles.lifetime / $Particles.speed_scale
	lifetime += 0.1
	$Particles.emitting = true
	$Timer.start(lifetime)
	# warning-ignore:return_value_discarded
	$Timer.connect("timeout", self, "queue_free")

