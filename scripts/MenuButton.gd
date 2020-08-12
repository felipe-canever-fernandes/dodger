extends Button
class_name GameButton

export(AudioStream) var hover_sound: AudioStream
export(AudioStream) var click_sound: AudioStream

onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _on_mouse_entered():
	if disabled:
		return
	
	audio_stream_player.stream = hover_sound
	audio_stream_player.play()

func _on_pressed():
	audio_stream_player.stream = click_sound
	audio_stream_player.play()
