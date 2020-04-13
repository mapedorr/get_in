extends AudioStreamPlayer
# ♪ Controla la reproducción de efectos de sonido dentro del juego ♪
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Variables ░░░░
var _sources: Array = []
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ Funciones ░░░░
func _ready():
	for src in get_children():
		_sources.append(src.name)
	
	Events.connect('play_requested', self, 'play_sound')
	Events.connect('stop_requested', self, 'stop_sound')
	Events.connect('pause_requested', self, 'pause_sound')


func _get_audio(source, sound) -> Node:
	return get_node(''+source+'/'+sound)


func play_sound(source: String, sound: String) -> void:
	var audio: Node = _get_audio(source, sound)

	if audio.get('stream_paused'):
		audio.stream_paused = false
	else:
		audio.play()
		if audio is AudioStreamPlayer:
			if audio.is_connected('finished', self, '_on_finished'):
				return
			else:
				audio.connect('finished', self, '_on_finished', [source, sound])
		else:
			if audio.select_sound.is_connected('finished', self, '_on_finished'):
				return
			else:
				audio.select_sound.connect('finished', self, '_on_finished', [source, sound])


func stop_sound(source: String, sound: String) -> void:
	_get_audio(source, sound).stop()


func pause_sound(source: String, sound: String) -> void:
	var audio: Node = _get_audio(source, sound)
	
	if not audio.get('stream_paused'):
		audio.stream_paused = true


func _on_finished(source, sound):
	Events.emit_signal('stream_finished', source, sound)
