extends Spatial


func _enter_tree() -> void:
	EnemyObjectiveList.objective_added(global_transform.origin)

func sudoku() -> void:
	EnemyObjectiveList.objective_died()

# TMP
func _exit_tree() -> void:
	sudoku()