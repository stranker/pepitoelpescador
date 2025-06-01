extends Node

@export var sfx : AudioStreamPlayer
@export var music : AudioStreamPlayer

@export var main_music : AudioStreamMP3
@export var button_sound : AudioStreamWAV

func play_sfx(sound : AudioStreamWAV):
	sfx.stream = sound
	sfx.play()
	pass

func play_music(music_theme : AudioStreamMP3):
	music.stream = music_theme
	music.play()
	pass

func play_main_music():
	play_music(main_music)
	pass

func play_button_sound():
	sfx.pitch_scale = randf_range(0.9, 1.1)
	play_sfx(button_sound)
	pass
