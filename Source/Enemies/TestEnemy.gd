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
	
	$EnemyStateMachine/PathfindTarget.nav = navigation
	$EnemyStateMachine/PathfindTarget.player = Globals.player
	$EnemyStateMachine/PathfindTarget._body = self
	
	init_signals()

func init_signals():
	$EnemyStateMachine/PathfindTarget.connect("direction_changed", $Legs, "set_direction")
