class_name PlantConfig extends Resource

@export var stages: Array[GrowthStage]

func validate():
	assert(stages.size() > 0)

func tooltip() -> String:
	if stages.is_empty():
		return ""
	var stage = stages[-1]
	var grow_time = stage.day
	var min_yield = stage.item_drop.min_count
	var max_yield = stage.item_drop.max_count
	return "[Grow Time: %d Days] [Yield: %d-%d]" % [grow_time, min_yield, max_yield]
