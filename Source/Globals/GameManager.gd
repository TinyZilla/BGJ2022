extends Node

# This is where all the sequence is gonna be

var event_queue: Array = []

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
		"next_event_trigger_at": 3
	},
	{
		"action": "spawn_enemies",
		"enemies": {
			"EnemyFollowers": 10
		},
		"next_event_trigger_at": 0
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

# Actually start the game.
func start() -> void:
	event_queue = event_list.duplicate(true)

	for event in event_queue:
		print(event.action)
		match event.action:
			"pause":
				yield(get_tree().create_timer(event.duration), "timeout")
			"skyfall":
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
					# Do some BS here.
					print("Resetting. Currently Doing nothgin")
			
