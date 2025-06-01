class_name Card
extends Resource

enum CardType {
	CHARACTER,
	UPGRADE,
	DIVINITY
}

@export var card_name : String
@export var card_texture : Texture
@export var card_description : String
var card_type : CardType

func get_description():
	return "Placeholder"
