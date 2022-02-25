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
			"EnemyFollowers": 10
		},
		"next_event_trigger_at": 3,
		"reset_from_index": 2
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 10
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
		"group": "intermission2"
	},
]

var current_index: int = 0

func do_event() -> void:
	if current_index >= event_list.size():
		print("Ran out of events....... WUT")
		return

	var event = event_list[current_index]
	print(event.action)

	match event.action:
		"pause":
			yield(get_tree().create_timer(event.duration), "timeout")
		"skyfall":
			if WaveManager.reset:
				current_index += 1
				return

			SkyfallManager.drop_group(event.group)
			yield(SkyfallManager, "skyfall_finished")
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

				# Wait 10 Second.
				print("Pausing 10 seconds ......")
				yield(get_tree().create_timer(10.0), "timeout")

				# Resume from a Checkpoint
				print("Resuming......")
				current_index = event.get("reset_from_index", 0)
	current_index += 1


# Actually start the game.
func start() -> void:

	while current_index < event_list.size():
		yield(do_event(), "completed")
	
	print("Out of Start Loop. Game done.")

			
