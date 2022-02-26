extends Node

# This is where all the sequence is gonna be

var event_list: Array = [
	{
		"action": "pause",
		"duration": 1.0
	},
	{
		"action": "skyfall",
		"group": "default"
	},
	{
		"action": "reset_objective",
		"group": "objective_stage_1"
	},
	{
		"action": "pause",
		"duration": 1.0
	},
	{
		"action": "skyfall_objective",
		"group": "objective_stage_1"
	},
	{
		"action": "pause",
		"duration": 1.0
	},
	{
		"action": "viewchange"
	},
	{
		"action": "pause",
		"duration": 5.0
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 1,
			"EnemyChasers": 1
		},
		"next_event_trigger_at": 1,
		"reset_from_index": 2
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 1
		},
		"next_event_trigger_at": 0,
		"reset_from_index": 2
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
		"action": "skyfall",
		"group": "stage2"
	},
	{
		"action": "reset_objective",
		"group": "objective_stage_2"
	},
	{
		"action": "pause",
		"duration": 1.0
	},
	{
		"action": "skyfall_objective",
		"group": "objective_stage_2"
	},
	{
		"action": "pause",
		"duration": 1.0
	},
	{
		"action": "viewchange"
	},
	{
		"action": "pause",
		"duration": 5.0
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 2
		},
		"next_event_trigger_at": 1,
		"reset_from_index": 14
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 2
		},
		"next_event_trigger_at": 0,
		"reset_from_index": 14
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
