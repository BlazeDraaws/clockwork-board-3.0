extends Node

# === STORAGE ===
var entities: Array = []
var beat_components: Array = []

var entity_to_beat := {}   # Entity -> BeatComponent
var beat_to_entity := {}   # BeatComponent -> Entity



# === REGISTER ===
func register_entity(entity: Node):
	if entity in entities:
		return
	
	entities.append(entity)

	# auto-unregister on removal
	entity.tree_exited.connect(func():
		unregister_entity(entity)
	)


func register_beat(beat: Node):
	if beat in beat_components:
		return
	
	beat_components.append(beat)

	# auto-unregister on removal
	beat.tree_exited.connect(func():
		unregister_beat(beat)
	)


func link(entity: Node, beat: Node):
	if not is_instance_valid(entity) or not is_instance_valid(beat):
		return
	
	entity_to_beat[entity] = beat
	beat_to_entity[beat] = entity


# === UNREGISTER ===
func unregister_entity(entity: Node):
	entities.erase(entity)

	if entity_to_beat.has(entity):
		var beat = entity_to_beat[entity]
		entity_to_beat.erase(entity)
		beat_to_entity.erase(beat)


func unregister_beat(beat: Node):
	beat_components.erase(beat)

	if beat_to_entity.has(beat):
		var entity = beat_to_entity[beat]
		beat_to_entity.erase(beat)
		entity_to_beat.erase(entity)


# === CLEANUP (failsafe) ===
func clean():
	# Clean entity list
	entities = entities.filter(func(e): return is_instance_valid(e))
	beat_components = beat_components.filter(func(b): return is_instance_valid(b))

	# Clean links
	for entity in entity_to_beat.keys():
		if not is_instance_valid(entity):
			var beat = entity_to_beat[entity]
			entity_to_beat.erase(entity)
			beat_to_entity.erase(beat)

	for beat in beat_to_entity.keys():
		if not is_instance_valid(beat):
			var entity = beat_to_entity[beat]
			beat_to_entity.erase(beat)
			entity_to_beat.erase(entity)


# === GETTERS ===
func get_all_entities():
	clean()
	return entities


func get_all_beats():
	clean()
	return beat_components


func get_beat(entity: Node):
	if entity_to_beat.has(entity):
		return entity_to_beat[entity]
	return null


func get_entity(beat: Node):
	if beat_to_entity.has(beat):
		return beat_to_entity[beat]
	return null


func get_entities_with_beats():
	clean()
	var result := []
	for entity in entity_to_beat:
		result.append({
			"entity": entity,
			"beat": entity_to_beat[entity]
		})
	return result


# === GAMEPLAY HELPERS ===

func get_random_entities(count: int):
	clean()
	var pool = entities.duplicate()
	pool.shuffle()
	return pool.slice(0, count)


func get_entities_by_group(group_name: String):
	clean()
	return entities.filter(func(e): return e.is_in_group(group_name))


func get_random_from_group(group_name: String, count: int):
	var pool = get_entities_by_group(group_name)
	pool.shuffle()
	return pool.slice(0, count)
