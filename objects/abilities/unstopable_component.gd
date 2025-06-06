extends AbilityComponent

func on_activate():
	get_tree().call_group("hook", "set_decrease_speed", ability.modifier)
	pass
