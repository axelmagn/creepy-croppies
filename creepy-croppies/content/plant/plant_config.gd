class_name PlantConfig extends Resource

@export var stages: Array[GrowthStage]

func validate():
	assert(stages.size() > 0)
