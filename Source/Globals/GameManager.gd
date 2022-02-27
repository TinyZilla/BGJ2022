extends Node

# This is where all the sequence is gonna be

var event_list: Array = [
	{	# 0
		"action": "pause",
		"duration": 1.0
	},
	{	#1
		"action": "skyfall",
		"group": "default"
	},
	{	#2
		"action": "reset_objective",
		"group": "objective_stage_1"
	},
	{	#3
		"action": "pause",
		"duration": 1.0
	},
	{	#4
		"action": "skyfall_objective",
		"group": "objective_stage_1"
	},
	{	#5
		"action": "pause",
		"duration": 3.0
	},
	{	#6
		"action": "viewchange"
	},
	{	#7
		"action": "pause",
		"duration": 6.0
	},
	{	#8
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 2,
			"EnemyChasers": 2
		},
		"next_event_trigger_at": 2,
		"reset_from_index": 2
	},
	{	#9
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 6,
			"EnemyChasers": 4
		},
		"next_event_trigger_at": 4,
		"reset_from_index": 2
	},
	{	#10
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 10,
			"EnemyChasers": 5
		},
		"next_event_trigger_at": 0,
		"reset_from_index": 2
	},
	{	#11
		"action": "pause",
		"duration": 2.0
	},
	{	#12
		"action": "viewchange"
	},
	{	#13
		"action": "pause",
		"duration": 2.0
	},
	{	#14
		"action": "skyfall",
		"group": "stage2"
	},
	{	#15
		"action": "reset_objective",
		"group": "objective_stage_2"
	},
	{	#16
		"action": "pause",
		"duration": 1.0
	},
	{	#17
		"action": "skyfall_objective",
		"group": "objective_stage_2"
	},
	{	#18
		"action": "pause",
		"duration": 3.0
	},
	{	#19
		"action": "viewchange"
	},
	{	#20
		"action": "pause",
		"duration": 5.0
	},
	{	#21
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 10,
			"EnemyChasers": 3
		},
		"next_event_trigger_at": 6,
		"reset_from_index": 15
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 10,
			"EnemyChasers": 6
		},
		"next_event_trigger_at": 6,
		"reset_from_index": 15
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 15,
			"EnemyChasers": 3
		},
		"next_event_trigger_at": 4,
		"reset_from_index": 15
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 40,
			"EnemyChasers": 10
		},
		"next_event_trigger_at": 0,
		"reset_from_index": 15
	},
	{
		"action": "pause",
		"duration": 2.0
	},
	{
		"action": "viewchange"
	},
	{
		"action": "pause",
		"duration": 2.0
	},
	{
		"action": "end_game"
	}
]

var current_index: int = 0

func do_event() -> void:
	if current_index >= event_list.size():
		print("Ran out of events....... WUT")
		return

	var event = event_list[current_index]
	print(event.action)

	match event.action:
		"end_game":
			Globals.user_interface.show_end_screen()
			yield(get_tree().create_timer(0.1), "timeout")
		"pause":
			yield(get_tree().create_timer(event.duration), "timeout")
		"skyfall":
			if WaveManager.reset:
				current_index += 1
				return

			if event.group == "stage2":
				Globals.navigation.swap_nav_mesh()
			SkyfallManager.drop_group(event.group)
			yield(SkyfallManager, "skyfall_finished")
		"skyfall_objective":
			SkyfallManager.drop_group(event.group)
			yield(SkyfallManager, "skyfall_finished")
			EnemyObjectiveList.ready_obj_group(event.group)
		"reset_objective":
			EnemyObjectiveList.reset_objective_list(event.group)
			if WaveManager.reset:
				yield(get_tree().create_timer(3.0), "timeout")
				Globals.user_interface.show_retry_menu()
				yield(Globals.user_interface, "resume_pressed")
			else:
				# Idk why this is needed but Godot yell at me if it's not here.....
				yield(get_tree().create_timer(0.1), "timeout")
		"viewchange":
			StateTransitionManager.transition()
			yield(StateTransitionManager, "transition_finished")
		"spawn_enemies":
			WaveManager.ready_wave()
			WaveManager.spawn_wave(event)
			yield(WaveManager, "wave_ended")

			if WaveManager.reset:
				# Move back to my pre-transition State.
				print("Resetting......")
				StateTransitionManager.transition()
				yield(StateTransitionManager, "transition_finished")

				# Resume from a Checkpoint
				print("Resuming......")
				current_index = event.get("reset_from_index", 0)
				return
	current_index += 1


# Actually start the game.
func start() -> void:
	while current_index < event_list.size():
		yield(do_event(), "completed")
	
	print("Out of Start Loop. Game done.")
