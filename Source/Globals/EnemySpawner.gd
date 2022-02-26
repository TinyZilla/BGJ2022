extends Node

# List of Spawn points.
# List of Enemy Types.
# Function to spawn enemy type. Spawn location random.
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var spawn_points: Array = []
var spawn_dict: Dictionary = {
	"EnemyFollowers": preload("res://Source/Enemies/EnemyFollowers.tscn"),
	"EnemyChasers": preload("res://Source/Enemies/EnemyChaser.tscn")
}

func _init() -> void:
	rng.randomize()

func add_spawn_point(location: Vector3) -> void:
	spawn_points.append(location)

func spawn(type: String) -> void:
	if spawn_points.empty() or not spawn_dict.has(type):
		print("No Spawn point or no enemy type.")
		return
	
	var clone = spawn_dict.get(type).instance()
	get_tree().current_scene.get_node("EnemyContainer").add_child(clone)
	clone.global_transform.origin = spawn_points[rng.randi_range(0, spawn_points.size() - 1)]
