class_name AbilityInfo
extends Control

@export var image : TextureRect
@export var title : Label
@export var requirement : Label
@export var description : RichTextLabel

func set_data(ability : Ability):
	image.texture = ability.texture
	title.text = ability.name
	description.text = ability.description
	requirement.text = "Lvl " + str(ability.level_requirement)
	pass
