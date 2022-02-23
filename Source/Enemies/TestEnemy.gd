extends KinematicBody


# Reference to the navigation node.
export(NodePath) var nav_path: NodePath

var navigation: Navigation

onready var bodyshot_position = $Pivoit/Body/BodyshotPosition

func _ready() -> void:
	assert(not nav_path.is_empty(), name + " don't have a nav instance")
	navigation = get_node(nav_path)
	assert(not Globals.player == null, "Player is null. Come up with a better way to do things dumbass.")
	
	$EnemyStateMachine.nav = navigation
	$EnemyStateMachine.player = Globals.player
	$EnemyStateMachine._body = self
	# Might be a shitty way to set required vars, Tiny pls halp ^^^
	
	init_signals()

func init_signals():
	$EnemyStateMachine/PathfindTarget.connect("direction_changed", $Legs, "set_direction")
	$EnemyStateMachine/Chase.connect("direction_changed", $Legs, "set_direction")
	$EnemyStateMachine/PathfindTarget.connect("direction_changed", $Pivoit, "direction_changed")
	$EnemyStateMachine/Chase.connect("direction_changed", $Pivoit, "direction_changed")
