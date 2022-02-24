extends KinematicBody
class_name Player

onready var bodyshot_position = $Body/BodyshotPosition

func _enter_tree() -> void:
	Globals.player = self

func _mouse_moved_x(pixel: float) -> void:
	rotation_degrees.y -= pixel * Globals.mouse_sensitivity

# TMP
func _ready() -> void:
	# spawn()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		SkyfallManager.drop_group("default")
	if event.is_action_pressed("ui_up"):
		StateTransitionManager.transition()

func spawn() -> void:
	EnemySpawner.spawn("EnemyFollowers")
	yield(get_tree().create_timer(2.0), "timeout")
	EnemySpawner.spawn("EnemyFollowers")
	yield(get_tree().create_timer(2.0), "timeout")
	EnemySpawner.spawn("EnemyFollowers")
	yield(get_tree().create_timer(2.0), "timeout")
	EnemySpawner.spawn("EnemyFollowers")
	yield(get_tree().create_timer(2.0), "timeout")
	EnemySpawner.spawn("EnemyFollowers")
