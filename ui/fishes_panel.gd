extends Control

@export var fishes_grid : GridContainer
@export var card_scene : PackedScene

func set_fishes(fishes : Array[FishData]):
	if fishes_grid.get_child_count() > 0:
		for card in fishes_grid.get_children():
			card.queue_free()
	for fish in fishes:
		var fish_card : Control = card_scene.instantiate()
		fishes_grid.add_child(fish_card)
		fish_card.set_fish_data(fish)
	pass


func show_fishes():
	for fish_card in fishes_grid.get_children():
		fish_card.show_data()
	pass
