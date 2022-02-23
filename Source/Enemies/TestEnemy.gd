extends KinematicBody


# Reference to the navigation node.
export(NodePath) var nav_path: NodePath

var navigation: Navigation

func _ready() -> void:
	assert(not nav_path.is_empty(), name + " don't have a nav instance")
	navigation = get_node(nav_path)
	assert(not Globals.player == null, "Player is null. Come up with a better way to do things dumbass.")
	$EnemyBrain.nav = navigation
	$EnemyBrain.player = Globals.player
