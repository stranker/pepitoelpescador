class_name AbilityInfo
extends Control

@export var image : TextureRect
@export var title : Label
@export var requirement : Label
@export var type : Label
@export var description : RichTextLabel

func set_data(ability : Ability):
	type.text = ability.get_type_string()
	image.texture = ability.texture
	title.text = ability.name
	description.text = ability.description
	requirement.text = "Lvl " + str(ability.level_requirement)
	pass
