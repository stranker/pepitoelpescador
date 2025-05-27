class_name AbilityComponent
extends Node

var ability : Ability

func set_data(data : Ability):
	ability = data
	if ability.type == Ability.AbilityType.ACTIVE:
		get_tree().call_group("ui", "add_ability_button", self)
	else:
		activate()
	pass

func activate():
	on_activate()
	pass

func on_activate():
	pass
